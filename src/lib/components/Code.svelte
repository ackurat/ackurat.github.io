<script>
	export let id = null
	export let lines = null
	export let noescape = false
</script>

<pre data-id={id || null}>
	<code data-trim data-line-numbers={lines || null} data-noescape={noescape || null}>
		<slot />
	</code>
</pre>
