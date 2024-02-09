<script>
	import { base } from '$app/paths'

	export let posts = []
</script>

<ul class="posts-list">
	{#each posts as post}
		<li>
			<article>
				<a href="{base}/blog/{post.slug}">
					{#if post.coverImage}
						<img
							src="{base}/{post.coverImage}"
							alt=""
							width={post.coverWidth}
							height={post.coverHeight}
							style="ratio: {post.coverWidth} / {post.coverHeight}" />
					{/if}

					<h2>{post.title}</h2>
				</a>

				{#if post.categories}
					<aside class="postlist-categories">
						<ul>
							{#each post.categories as category}
								<li>
									<a href="{base}/blog/category/{category}/">{category}</a>
								</li>
							{/each}
						</ul>
					</aside>
				{/if}
			</article>

			<p>{post.excerpt}</p>
		</li>
	{/each}
</ul>
