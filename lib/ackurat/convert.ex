defmodule Ackurat.Convert do
  require Logger

  def convert(_path, body, _attrs, _optds) do
    Djot.to_html!(body)
    |> Floki.parse_fragment!()
    |> highlight_code()
    |> Floki.raw_html()
  end

  defp highlight_code(ast) do
    ast
    |> Floki.traverse_and_update(fn
      {"pre", _, [{"code", _, _}]} = node ->
        block_code(node)

      {"code", _, _} = node ->
        inline_code(node)

      node ->
        node
    end)
  end

  defp block_code({"pre", _, [{"code", attrs, children}]}) do
    language =
      Enum.find_value(attrs, fn
        {"class", <<"language-" <> language>>} -> language
        _ -> false
      end)

    children
    |> Floki.text()
    |> Autumn.highlight!(
      language: language,
      formatter:
        {:html_multi_themes,
         themes: [light: "catppuccin_latte", dark: "catppuccin_mocha"],
         default_theme: "light-dark()"}
    )
    |> Floki.parse_fragment!()
    |> Floki.find("pre")
    |> hd()
  end

  defp inline_code({"code", attrs, children}) do
    language =
      Enum.find_value(attrs, fn
        {"class", <<"language-" <> language>>} -> language
        _ -> false
      end)

    {"code", code_attrs, code_children} =
      children
      |> Floki.text()
      |> Autumn.highlight!(
        language: language,
        formatter:
          {:html_multi_themes,
           themes: [light: "catppuccin_latte", dark: "catppuccin_mocha"],
           default_theme: "light-dark()"}
      )
      |> Floki.parse_fragment!()
      |> Floki.find("code")
      |> hd()

    unwrapped_children =
      Enum.flat_map(code_children, fn
        {"div", _, div_children} -> div_children
        other -> [other]
      end)

    {"code", code_attrs, unwrapped_children}
  end
end
