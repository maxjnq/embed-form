import { parseWithZod } from '@conform-to/zod'
import { invariantResponse } from '@epic-web/invariant'
import {
	type ActionFunctionArgs,
	type HeadersFunction, json } from '@remix-run/node'
import { nanoid } from 'nanoid'
import { z } from 'zod'
import { prisma } from '#app/utils/db.server'
import { checkHoneypot } from '#app/utils/honeypot.server'


export const EmailSchema = z.object({
	email: z.string().email('Invalid email'),
})

export const headers: HeadersFunction = () => ({
	'Access-Control-Allow-Origin': '*',
	'Access-Control-Allow-Methods': 'POST',
	'Access-Control-Allow-Headers':
		'Content-Type, Authorization, X-Requested-With',
	'Access-Control-Allow-Credentials': 'true',
})

// export async function loader({ request }: LoaderFunctionArgs) {
// 	return json(
// 		{ request },
// 		{
// 			headers: {
// 				"Access-Control-Allow-Origin": "*",
// 			},
// 		}
// 	)
// }

export async function action({ params, request }: ActionFunctionArgs) {
	const { listId } = params
	const formData = await request.formData()
	const domain = "http://localhost:3000" // getEnv('DOMAIN')
	const list = await prisma.list.findUnique({
		where: { id: listId },
		select: { id: true, signUpPage: { select: { redirectUrl: true } } },
	})

	invariantResponse(list, 'List not found', { status: 404 })
	checkHoneypot(formData)

	const submission = await parseWithZod(formData, {
		schema: EmailSchema.superRefine(async (data, ctx) => {
			const sub = await prisma.sub.findFirst({
				where: {
					AND: [{ email: data.email }, { listId: list.id }],
				},
			})

			if (sub) {
				ctx.addIssue({
					path: ['email'],
					code: z.ZodIssueCode.custom,
					message: 'Already subscribed',
				})
				return
			}

			// check if user can create a new sub
			// ...waiting for subscription implementation
		}),
		async: true,
	})

	if (submission.status !== 'success') {
		console.log('error', submission.reply().error?.email)
		return json({
			res: {
				error: submission.reply().error?.email,
				redirect: undefined,
			},
		})
	}

	const { email } = submission.value

	const sub = await prisma.sub.create({
		data: {
			email,
			shortId: nanoid(8),
			list: { connect: { id: listId } },
		},
		select: {
			shortId: true,
		},
	})

	const redirect = list.signUpPage?.redirectUrl
		? list.signUpPage?.redirectUrl
		: `${domain}/me/${sub.shortId}`

	return json({ res: { error: undefined, redirect } }, 		
		{
		headers: 
			{
				"Access-Control-Allow-Origin": "*",
			},
	})
}
