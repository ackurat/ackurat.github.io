defmodule Ackurat.Pages do
  use NimblePublisher,
    build: Ackurat.Page,
    from: Application.app_dir(:ackurat, "priv/pages/**/*.{md,dj}"),
    as: :pages,
    highlighters: [],
    html_converter: Ackurat.Convert

  def pages, do: @pages

  def get_by_slug(slug) do
    pages() |> Enum.find(not_found_page(), &(&1.id == slug))
  end

  def about_page do
    pages() |> Enum.find(&(&1.id == "about"))
  end

  def not_found_page do
    pages() |> Enum.find(&(&1.id == "404"))
  end
end
