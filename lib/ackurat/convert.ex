defmodule Ackurat.Convert do
  def convert(_path, body, _attrs, _optds) do
    block_regex = ~r/<pre><code(?:\s+class="language-(\w*)")?>([^<]*)<\/code><\/pre>/
    inline_regex = ~r/<code(?:\s+class="language-(\w*)")?>([^<]*)<\/code>/

    Djot.to_html!(body)
    |> NimblePublisher.highlight(regex: block_regex)
    |> highlight_inline(inline_regex)
  end

  defp highlight_inline(html, regex) do
    Regex.replace(regex, html, fn (block, _lang, _code) ->
        NimblePublisher.highlight(block, regex: regex)
        |> String.replace(~r/<pre>(.*)<\/pre>/s, "\\1")
    end)
  end
end
