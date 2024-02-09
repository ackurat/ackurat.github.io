<script>
	import { base } from '$app/paths'

	export let data

	const {
		title,
		excerpt,
		date,
		updated,
		author,
		coverImage,
		coverWidth,
		coverHeight,
		categories
	} = data.meta
	const { PostContent } = data
</script>

<!-- This file renders each individual blog post for reading. Be sure to update the svelte:head below -->
<svelte:head>
	<!-- Be sure to add your image files and un-comment the lines below -->
	<title>{title}</title>
	<meta data-key="description" name="description" content={excerpt} />
	<meta property="og:type" content="article" />
	<meta property="og:title" content={title} />
	<meta name="twitter:title" content={title} />
	<meta property="og:description" content={excerpt} />
	<meta name="twitter:description" content={excerpt} />
	<!-- <meta property="og:image" content="https://yourdomain.com/image_path" /> -->
	<meta property="og:image:width" content={coverWidth} />
	<meta property="og:image:height" content={coverHeight} />
	<!-- <meta name="twitter:image" content="https://yourdomain.com/image_path" /> -->
</svelte:head>

<article class="post">
	<!-- You might want to add an alt frontmatter attribute. If not, leaving alt blank here works, too. -->
	{#if coverImage}
		<img
			class="cover-image"
			src="{base}/{coverImage}"
			alt=""
			style="aspect-ratio: {coverWidth} / {coverHeight};"
			width={coverWidth}
			height={coverHeight} />
	{/if}

	<h1>{title}</h1>

	<div class="meta">
		<b>Publicerad:</b>
		{date}
		<br />
		<b>Av:</b>
		{author}
	</div>

	<svelte:component this={PostContent} />

	{#if categories}
		<aside class="post-footer">
			<h2>Posted in:</h2>
			<ul>
				{#each categories as category}
					<li>
						<a href="{base}/blog/category/{category}/">{category}</a>
					</li>
				{/each}
			</ul>
		</aside>
	{/if}
</article>
