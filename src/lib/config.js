import { base } from '$app/paths'

export const siteTitle = 'Adam CL'
export const siteDescription = 'Personal website of Adam CL'
export const siteURL = 'ackurat.github.io'
export const siteLink = 'https://ackurat.github.io'
export const siteAuthor = '- Adam CL'

// Controls how many posts are shown per page on the main blog index pages
export const postsPerPage = 10

// Edit this to alter the main nav menu. (Also used by the footer and mobile nav.)
export const navItems = [
	{
		title: 'Articles',
		route: `${base}/blog`
	},
	{
		title: 'Categories',
		route: `${base}/blog/category`
	}
]
