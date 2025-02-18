defmodule Ackurat.Convert do
  def convert(_path, body, _attrs, _optds) do

    Djot.to_html!(body)
    |> highlight_block_code()
    |> highlight_inline_code()
  end

  defp highlight_block_code(body) do
    block_code = ~r/<pre><code(?:\s+class="language-(\w*)")?>([^<]*)<\/code><\/pre>/

    NimblePublisher.highlight(body, regex: block_code)
  end

  defp highlight_inline_code(body) do
    inline_code = ~r/(?<!<pre>)<code(?:\s+class="language-(\w*)")?>([^<]*)<\/code>/

    Regex.replace(inline_code, body, fn (block, _lang, _code) ->
        NimblePublisher.highlight(block, regex: inline_code)
        |> String.replace(~r/<pre>(.*)<\/pre>/s, "\\1")
    end)
  end
end
