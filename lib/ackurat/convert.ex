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
         default_theme: "light-dark()"}
    )
    |> Floki.parse_fragment!()
    |> Floki.find("pre")
    |> hd()
    |> add_pre_styles()
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

    {"code", code_attrs, unwrapped_children}
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

  defp add_pre_styles({"pre", pre_attrs, pre_children}) do
    updated_attrs = add_or_merge_class(pre_attrs, "relative")

    updated_children =
      Enum.map(pre_children, fn
        {"code", code_attrs, code_children} ->
          {"code", add_or_merge_class(code_attrs, "block overflow-x-auto"), code_children}

        other ->
          other
      end)

    {"pre", updated_attrs, updated_children}
  end

  defp add_or_merge_class(attrs, new_classes) do
    case List.keyfind(attrs, "class", 0) do
      {"class", existing_classes} ->
        List.keyreplace(attrs, "class", 0, {"class", existing_classes <> " " <> new_classes})

      nil ->
        [{"class", new_classes} | attrs]
    end
  end
end
