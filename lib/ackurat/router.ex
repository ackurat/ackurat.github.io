defmodule Ackurat.Router do
  use Plug.Router

  alias Ackurat.Posts
  alias Ackurat.Render.Layout
  alias Ackurat.Render.Post
  alias Ackurat.Render.Pages

  plug(Plug.Logger, log: :info)
  plug(:put_headers)
  plug(:handle_redirects)

  plug(Plug.Static,
    at: "/",
    from: :ackurat,
    only: ~w(favicon.ico images robots.txt style.css),
    gzip: true,
    cache_control_for_etags: "public, max-age=31536000, immutable",
    headers: %{"cache-control" => "public, max-age=3600"}
  )

  plug(:match)
  plug(:dispatch)

  defp put_headers(conn, _opts) do
    conn
    |> put_resp_header("x-frame-options", "SAMEORIGIN")
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("x-xss-protection", "1; mode=block")
    |> put_resp_header("referrer-policy", "strict-origin-when-cross-origin")
    |> put_resp_header("permissions-policy", "geolocation=(), microphone=(), camera=()")
  end

  defp handle_redirects(conn, _opts) do
    request_path = "/" <> Enum.join(conn.path_info, "/")

    redirects = %{
      "/feed.xml" => "/feed",
      "/rss.xml" => "/feed",
      "/feed/index.html" => "/feed",
      "/blog/index.html" => "/",
      "/post/index.html" => "/",
      "/posts/index.html" => "/"
    }

    case Map.get(redirects, request_path) do
      nil ->
        conn

      target ->
        conn
        |> put_resp_header("location", target)
        |> put_resp_header("cache-control", "public, max-age=31536000")
        |> send_resp(301, "")
        |> halt()
    end
  end

  defp render(component) do
    component
    |> Phoenix.HTML.Safe.to_iodata()
  end

  get "/" do
    posts = Posts.active_posts() |> Enum.take(5)
    html = render(Pages.index(%{posts: posts}))

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, html)
  end

  get "/archive" do
    posts = Posts.active_posts()
    tags = Posts.all_keywords()

    html = render(Pages.archive(%{posts: posts, tags: tags}))

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, html)
  end

  get "/keywords/:keyword" do
    keyword = conn.path_params["keyword"]

    html = render(Pages.keyword(keyword))

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, html)
  end

  get "/feed" do
    xml = Ackurat.Render.Rss.rss(Posts.active_posts())

    conn
    |> put_resp_header("content-type", "application/xml")
    |> put_resp_header("cache-control", "no-cache")
    |> send_resp(200, xml)
  end

  get "/sitemap.xml" do
    xml = Ackurat.Render.Layout.sitemap(Ackurat.Content.content())

    conn
    |> put_resp_header("content-type", "application/xml")
    |> put_resp_header("cache-control", "no-cache")
    |> send_resp(200, xml)
  end

  get "/posts/:id" do
    post = Posts.post_by_id(id)

    html =
      render(
        Post.post(%{
          title: post.title,
          description: post.description,
          body: post.body,
          route: post.route,
          date: post.date,
          keywords: post.keywords,
          id: post.id,
          toc: post.toc || []
        })
      )

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, html)
  end

  get "/:slug" do
    page = Ackurat.Pages.get_by_slug(slug)

    html =
      render(
        Layout.page(%{
          title: page.title,
          description: page.description,
          body: page.body,
          route: page.route
        })
      )

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> put_resp_header("cache-control", "public, max-age=3600")
    |> send_resp(200, html)
  end
end
