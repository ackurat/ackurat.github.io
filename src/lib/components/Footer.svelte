<script>
	import MainNav from './MainNav.svelte'
	import { siteAuthor } from '$lib/config'
	import { base } from '$app/paths'
</script>

<footer>
	<MainNav />

	<nav>
		<ul>
			<li>
				<a href="{base}/api/rss.xml" data-sveltekit-reload>RSS</a>
			</li>
			<li>
				<a href="{base}/">Home</a>
			</li>
		</ul>
	</nav>

	<p>&copy;{new Date().getFullYear()} {siteAuthor}</p>
</footer>
