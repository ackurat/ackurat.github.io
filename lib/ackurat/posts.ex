defmodule Ackurat.Posts do
  @moduledoc false

  alias Ackurat.Parser

  use NimblePublisher,
    build: Ackurat.Post,
    parser: Parser,
    from: Application.app_dir(:ackurat, "priv/posts/**/*.{md,dj}"),
    as: :posts,
    highlighters: [],
    html_converter: Ackurat.Convert

  def posts, do: @posts |> Enum.sort_by(& &1.date, {:desc, Date})

  def post_by_id(id) do
    posts() |> Enum.find(&(&1.id == id))
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
    posts = posts()
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

  def active_posts() do
    case Mix.env() do
      :prod -> posts() |> Enum.reject(& &1.draft)
      :dev -> posts()
    end
  end
end
