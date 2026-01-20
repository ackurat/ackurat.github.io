defmodule Ackurat do
  @moduledoc """
  All functionality for rendering and building the site
  """

  require Logger
  alias Ackurat.Content
  alias Ackurat.Render

  @output_dir "./output"

  def assert_uniq_page_ids!(pages) do
    ids = pages |> Enum.map(& &1.id)
    dups = Enum.uniq(ids -- Enum.uniq(ids))

    if dups |> Enum.empty?() do
      :ok
    else
      raise "Duplicate pages: #{inspect(dups)}"
    end
  end

  def render_posts(posts) do
    for post <- posts do
      render_file(post.html_path, Render.Post.post(post))
    end
  end

  def render_keywords(keywords) do
    render_file("keywords/index.html", Render.Pages.keyword_index(Content.all_keywords()))

    for keyword <- keywords do
      render_file("keywords/" <> keyword <> "/index.html", Render.Pages.keyword(keyword))
    end
  end

  def render_redirects(redirects) do
    for {path, target} <- redirects do
      render_file(path, Render.Layout.redirect(%{target: target}))
    end
  end

  def build_pages(prod) do
    pages = Content.all_pages()
    active_posts = Content.active_posts(prod)
    all_keywords = Content.all_keywords()
    about_page = Content.about_page()
    assert_uniq_page_ids!(pages)
    render_file("index.html", Render.Pages.index(%{posts: active_posts}))
    render_file("404.html", Render.Layout.page(Content.not_found_page()))
    render_file(about_page.html_path, Render.Layout.page(about_page))
    render_file("archive/index.html", Render.Pages.archive(%{posts: active_posts}))
    write_file("index.xml", Render.Rss.rss(active_posts))
    write_file("sitemap.xml", Render.Layout.sitemap(pages))
    render_posts(active_posts)
    render_keywords(all_keywords)
    render_redirects(Content.redirects())
    :ok
  end

  def write_file(path, data) do
    dir = Path.dirname(path)
    output = Path.join([@output_dir, path])

    if dir != "." do
      File.mkdir_p!(Path.join([@output_dir, dir]))
    end

    File.write!(output, data)
  end

  def render_file(path, rendered) do
    safe = Phoenix.HTML.Safe.to_iodata(rendered)
    write_file(path, safe)
  end

  def build_all(prod \\ :prod) do
    Logger.info("Clear output directory")
    File.rm_rf!(@output_dir)
    File.mkdir_p!(@output_dir)
    Logger.info("Copying static files")
    File.cp_r!("assets/static", @output_dir)
    Logger.info("Building pages")

    {micro, :ok} =
      :timer.tc(fn ->
        build_pages(prod)
      end)

    ms = micro / 1000
    Logger.info("Pages built in #{ms}ms")
    Logger.info("Running tailwind")
    Mix.Tasks.Tailwind.run(["default"])
  end
end
