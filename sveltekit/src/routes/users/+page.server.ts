import { redirect as kitRedirect } from '@sveltejs/kit';
import type { PageServerLoad, Action } from './$types';
import { getFormData } from 'remix-params-helper';
import { z } from 'zod';
import e from '$db';
import { client } from '$lib/edgedb';

export const load: PageServerLoad = async ({ locals }) => {
	// locals.userid comes from src/hooks.ts
	const users = await e
		.select(e.User, (user) => ({
			id: true,
			username: true,
			name: true,
			password: true
		}))
		.run(client);

	return { users };
};

export const POST: Action = async ({ request, locals }) => {
	const schema = z.object({
		username: z.string(),
		name: z.string(),
		password: z.string()
	});
	const { data, errors, success } = await getFormData(request, schema);

	if (!success) {
		return { errors };
	}

	await e
		.insert(e.User, {
			username: data.username,
			name: data.name,
			password: data.password
		})
		.run(client);
};

// If the user has JavaScript disabled, the URL will change to
// include the method override unless we redirect back to /users
const redirect = kitRedirect(303, '/users');

export const PATCH: Action = async ({ request }) => {
	const schema = z.object({
		id: z.string().uuid(),
		username: z.string().optional(),
		name: z.string().optional(),
		password: z.boolean().optional()
	});
	const { data, errors, success } = await getFormData(request, schema);

	if (!success) {
		return { errors };
	}

	const { id, username, name, password } = data;
	await e
		.update(e.User, (user) => ({
			filter: e.op(user.id, '=', e.uuid(id)),
			set: { username, name, password }
		}))
		.run(client);

	throw redirect;
};

export const DELETE: Action = async ({ request }) => {
	const schema = z.object({
		id: z.string().uuid()
	});
	const { data, errors, success } = await getFormData(request, schema);

	if (!success) {
		return { errors };
	}

	await e
		.delete(e.User, (user) => ({
			filter: e.op(user.id, '=', e.uuid(data.id))
		}))
		.run(client);

	throw redirect;
};
