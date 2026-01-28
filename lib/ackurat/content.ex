defmodule Ackurat.Content do
  @moduledoc false

  alias Ackurat.Page
  alias Ackurat.Parser

  use NimblePublisher,
    build: Page,
    parser: Parser,
    from: "./pages/**/*.{md,dj}",
    as: :pages,
    highlighters: [],
    html_converter: Ackurat.Convert

  def site_title() do
    "ackurat.github.io"
  end

  def site_description() do
    "Ackurat's test thing"
  end

  def site_author() do
    "Adam CL"
  end

  def site_url() do
    "https://ackurat.github.io"
  end

  def site_email() do
    "dev@liliemark.se"
  end

  def site_copyright() do
    "This work is licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-nd/4.0/"
  end

  def redirects() do
    %{
      "/feed.xml" => "/index.xml",
      "/rss.xml" => "/index.xml",
      "/feed/index.html" => "/index.xml",
      "/blog/index.html" => "/",
      "/post/index.html" => "/",
      "/posts/index.html" => "/"
    }
  end

  def all_posts do
    @pages
    |> Enum.filter(&(&1.type == :post))
    |> Enum.sort_by(& &1.date, {:desc, Date})
  end

  def post_by_id(id) do
    all_posts() |> Enum.filter(&(&1.id == id))
  end

  def posts_by_keyword(keyword) do
    active_posts() |> Enum.filter(fn post -> keyword in post.keywords end)
  end

  def all_keywords do
    active_posts()
    |> Enum.flat_map(& &1.keywords)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def adjacent_posts(id) do
    posts = all_posts()
    idx = posts |> Enum.find_index(&(&1.id == id))
    previous = posts |> Enum.fetch(idx - 1)
    next = posts |> Enum.fetch(idx + 1)

    case {previous, next} do
      {{:ok, prev}, {:ok, nxt}} -> {prev.id, nxt.id}
      {:error, {:ok, nxt}} -> {nil, nxt.id}
      {{:ok, prev}, :error} -> {prev.id, nil}
      _ -> :error
    end
  end

  def active_posts(prod \\ :prod) do
    case prod do
      :prod -> all_posts() |> Enum.reject(& &1.draft)
      :dev -> all_posts()
    end
  end

  def pages do
    @pages
  end

  def about_page do
    pages() |> Enum.find(&(&1.id == "about"))
  end

  def not_found_page do
    pages() |> Enum.find(&(&1.id == "404"))
  end

  def all_pages do
    [about_page()] ++ active_posts()
  end
end
