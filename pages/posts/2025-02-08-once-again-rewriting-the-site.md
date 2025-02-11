%{
  title: "Once again rewriting the site",
  description: "I'm rewriting the site in Elixir, with NimblePublisher and LiveView templates as a base.",
  keywords: ["elixir", "zine"],
}

---


Once again I'm rewriting the site. I never got around to finishing my [Zine](https://zine-ssg.io) implementation, partly because I didn't have time to invest into learning Zig. I'll soon start a new job where I'll use [Elixir](https://elixir-lang.org) and [Erlang](https://erlang.org) as my main languages. I haven't used Erlang much before, but Elixir has been a lurking favourite, and with my experiments with [Gleam](https://gleam.run) I found renewed interest in it.

The site uses [NimblePublisher](https://github.com/dashbitco/nimble_publisher) and [LiveView](https://github.com/phoenixframework/phoenix_live_view) `HEEx` templates. The basis for the site is [Jason Stiebe's tutorial](https://fly.io/phoenix-files/crafting-your-own-static-site-generator-using-phoenix/), and after I had implemented a rudimentary version I forked [Jorin's website](https://jorin.me/) and started rebuilding it to my liking. Kudos to both these for saving me time! Unlike Jorin, I don't have a desire to create my site generator from scratch, but I'll happily spend time refactoring and tinkering.

## Upcoming changes

Inspired by [Jonas Hietala's microfeatures](https://www.jonashietala.se/blog/2024/07/09/microfeatures_in_my_blog/), I have some features I want to implement. Just like he states, microfeatures are fun and a way to learn. For instance, I've already implemented headings with automatic linking. It was pretty straight forward - reimplement the parsing of headings to add markdown links, and add a postprocessor to add the anchor ID to the headings:

```elixir
# parser.ex

defp replace_heading(line) do
  if String.starts_with?(line, "## ") do
    title = String.replace(line, "## ", "")
    slug =
      title
      |> String.downcase()
      |> String.replace(~r/[^a-z]+/, "-")
      |> String.trim("-")

    "## [#{title}](##{slug})"
  else
    line
  end
end

# processor.ex

def process({"h2", [], [text], %{}}) do
  case text do
    {_, [{_, anchor_id}], _, _} -> {"h2", [{"id", anchor_id |> String.trim("#")}], [text], %{}}
    _ -> {"h2", [], [text], %{}}
  end
end
```

### Djot support

One microfeature I really like in Jonas' blog is syntax highlighting in inline code. I could solve this by either writing the inline code as HTML:

```
This is some markdown with inline Elixir code: <code class="makeup elixir">def process(value), do: value</code>
```

Unfortunately, the markdown parser used by NimblePublisher, [Earmark](https://github.com/pragdave/earmark) doesn't support inline HTML. It's probably solvable by using a postprocessor, but that feels like a tedious rabbit hole. Instead, I want to take the same [path as Jonas](https://www.jonashietala.se/blog/2024/02/02/blogging_in_djot_instead_of_markdown/) and use [Djot](https://www.djot.net/) to write content. Djot supports adding [inline attributes](https://htmlpreview.github.io/?https://github.com/jgm/djot/blob/master/doc/syntax.html#inline-attributes) which could be used like this:

```
This is some markdown with inline Elixir code: `def process(value), do: value`{.makeup .elixir}
```

There are more features of Djot I could use, for instance footnotes.

### Less hand-written CSS

I'm using [TailwindCSS](https://tailwindcss.com/) to lessen the need of writing CSS, but since I use Earmark to produce the HTML of the post you're reading right now, it's not simple to use Tailwind for styling within the generated HTML. Instead, I've resorted to hand-writing CSS. I'm trying to minimize it and if I switch to Djot, I'll see if it's easier to have a post processing step to add Tailwind classes to the generated HTML.

### Typography improvements

The styling and typography is very basic right now. I like it basic, but I still think there is room for improvement. For instance, the header of this section is not very well separated stylistically.
