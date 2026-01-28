defmodule Ackurat.Convert do
  require Logger

  def convert(_path, body, _attrs, _opts) do
    Djot.to_html!(body)
    |> Floki.parse_fragment!()
    |> traverse()
    |> Floki.raw_html()
  end

  defp traverse(ast) do
    ast
    |> Floki.traverse_and_update(fn
      {"html", _, [{"head", _, _}, {"body", _, children}]} ->
        children

      {"pre", _, [{"code", _, _}]} = node ->
        block_code(node)

      {"code", _, _} = node ->
        inline_code(node)

      node ->
        node
    end)
  end

  defp block_code({"pre", _pre_attrs, [{"code", attrs, children}]}) do
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
         default_theme: "light-dark()",
         pre_class: "relative rounded-lg p-2"}
    )
    |> Floki.parse_fragment!()
    |> Floki.find("pre")
    |> hd()
    |> add_code_classes()
    |> add_language_label(language)
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

    {"code", List.keydelete(code_attrs, "tabindex", 0), unwrapped_children}
  end

  defp add_language_label({"pre", pre_attrs, pre_children}, language) when is_binary(language) do
    label = {
      "span",
      [
        {"class", "absolute top-0 right-4 -translate-y-full rounded-t-lg px-2 text-base"},
        {"style",
         "background-color: light-dark(var(--color-latte-base), var(--color-mocha-base)); color: light-dark(var(--color-latte-text), var(--color-mocha-text));"}
      ],
      [language]
    }

    {"pre", pre_attrs, [label | pre_children]}
  end

  defp add_code_classes(node) do
    Floki.traverse_and_update(node, fn child ->
      case child do
        {"code", code_attrs, code_children} ->
          updated_attrs =
            code_attrs
            |> append_classes("block overflow-x-auto")
            |> add_accessibility_attrs()

          {"code", updated_attrs, code_children}

        other ->
          other
      end
    end)
  end

  defp append_classes(attrs, additional_classes) do
    Enum.map(attrs, fn attr ->
      case attr do
        {"class", current} -> {"class", current <> " " <> additional_classes}
        attr -> attr
      end
    end)
  end

  defp add_accessibility_attrs(attrs) do
    attrs
    |> List.keystore("role", 0, {"role", "code"})
  end
end
