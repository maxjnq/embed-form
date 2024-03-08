import { redirect, type ActionFunctionArgs } from '@remix-run/node'
import { useFetcher } from '@remix-run/react'
import { StatusButton } from '#app/components/ui/status-button'
import { requireUserId } from '#app/utils/auth.server'
import { createList } from '#app/utils/list.server'

export async function action({ request }: ActionFunctionArgs) {
	const userId = await requireUserId(request)
	const formData = await request.formData()
	const name = formData.get('name') as string

	const res = await createList({
		name,
		userId,
	})

	if (res.id) {
		return redirect(`/admin/${res.id}/dashboard`)
	}
}

export default function CreateList() {
	const fetcher = useFetcher()

	return (
		<fetcher.Form
			method="post"
			className="relative flex flex-col items-center gap-6"
		>
			<input
				name="name"
				type="text"
				className="flex-grow bg-transparent text-center text-[64px] font-bold shadow-none focus-visible:outline-none focus-visible:ring-0"
				placeholder=""
				autoFocus
			/>
			<StatusButton
				variant="secondary"
				status={
					fetcher.state !== 'idle' ? 'pending' : 'idle'
				}
			>
				Create Project
			</StatusButton>
		</fetcher.Form>
	)

 
}
