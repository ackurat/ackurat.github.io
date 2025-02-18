defmodule Ackurat.Convert do
  def convert(_path, body, _attrs, _opts) do
    custom_regex = ~r/<pre><code(?:\s+class="language-(\w*)")?>([^<]*)<\/code><\/pre>/

    :jot.to_html(body)
    |> NimblePublisher.highlight(regex: custom_regex)
  end
end
