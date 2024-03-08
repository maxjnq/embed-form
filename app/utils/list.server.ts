import { type List, type User } from '@prisma/client'
import { sub } from 'date-fns'
import { nanoid } from 'nanoid'
import { prisma } from './db.server'
import forbidden from './forbidden.txt'

export async function forbiddenHandle(handle: string): Promise<boolean> {
	const forbiddenHandles = forbidden.split('\n')
	if (forbiddenHandles.includes(handle)) return true
	return false
}

export interface SuccessResponse {
	readonly status: 'success' | 'error'
	id?: string
}

export async function isAlreadySubscribed(
	listId: string,
	email: string,
): Promise<boolean> {
	const subscription = await prisma.sub.findFirst({
		where: {
			AND: [{ listId: listId }, { email: email }],
		},
	})

	// If a subscription was found, return true; otherwise, return false
	return subscription !== null
}

export async function createList({
	name,
	userId,
}: Pick<List, 'name'> & { userId: User['id'] }): Promise<SuccessResponse> {
	const listSettings = await prisma.listSettings.create({ data: {} })
	const listSignUpPage = await prisma.listSignUpPage.create({ data: {} })
	const listSignUpForm = await prisma.listSignUpForm.create({ data: {} })
	const listConfirmationPage = await prisma.listConfirmationPage.create({
		data: {},
	})
	const listConfirmationEmail = await prisma.listConfirmationEmail.create({
		data: {},
	})

	const newList = await prisma.list.create({
		data: {
			name,
			url: nanoid(8),
			userId,
			listSignUpPageId: listSignUpPage.id,
			listSignUpFormId: listSignUpForm.id,
			listConfirmationPageId: listConfirmationPage.id,
			listConfirmationEmailId: listConfirmationEmail.id,
			listSettingsId: listSettings.id,
		},
		select: {
			id: true,
		},
	})

	if (newList) {
		// Track event
		// await logsnag.track({
		// 	channel: 'lists',
		// 	event: `New list created: ${newList.name}`,
		// 	user_id: userId,
		// 	description: `wt.ls/${newList.url}`,
		// 	icon: '🥹',
		// 	notify: true,
		// })

		// Increment insight
		// await logsnag.insight.increment({
		// 	title: 'List Count',
		// 	value: 1,
		// 	icon: '🚀',
		// })

		return { status: 'success', id: newList.id }
	} else {
		return { status: 'error' }
	}
}

export async function getListSubCount(
	listId: string,
	period1Start: Date,
	period1End: Date,
	period2Start: Date,
	period2End: Date,
) {
	// Count subs in the first period
	const countPeriod1 = await prisma.sub.count({
		where: {
			listId,
			createdAt: {
				gte: period1Start,
				lte: period1End,
			},
		},
	})

	// Count subs in the second period
	const countPeriod2 = await prisma.sub.count({
		where: {
			listId,
			createdAt: {
				gte: period2Start,
				lte: period2End,
			},
		},
	})

	const totalCount = await prisma.sub.count({
		where: {
			listId,
		},
	})

	// Calculate growth percentage
	const growthPercentage = calculateGrowth(countPeriod1, countPeriod2)

	return {
		totalSubs: totalCount,
		growthPercentage,
	}
}

function calculateGrowth(previous: number, current: number): number {
	if (previous === 0) return 100 // Avoid division by zero
	return ((current - previous) / previous) * 100
}

export async function getListSubCount24(listId: string) {
	const periodEnd = new Date() // Current time
	const periodStart = sub(periodEnd, { days: 1 }) // 24 hours ago
	const previousPeriodStart = sub(periodStart, { days: 1 }) // 48 hours ago

	const currentPeriodCount = await prisma.sub.count({
		where: {
			listId,
			createdAt: {
				gte: periodStart,
				lt: periodEnd,
			},
		},
	})

	const previousPeriodCount = await prisma.sub.count({
		where: {
			listId,
			createdAt: {
				gte: previousPeriodStart,
				lt: periodStart,
			},
		},
	})

	// Calculate the growth percentage
	let growthPercentage = 0
	if (previousPeriodCount > 0) {
		growthPercentage =
			((currentPeriodCount - previousPeriodCount) / previousPeriodCount) * 100
	}

	return {
		count: currentPeriodCount,
		gr: growthPercentage,
	}
}
