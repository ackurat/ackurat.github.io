defmodule Ackurat.Render.Rss do
  def format_rss_date(date = %DateTime{}) do
    Calendar.strftime(date, "%a, %d %b %Y %H:%M:%S %z")
  end

  def format_rss_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_rss_date()
  end

  def rss_post_limit() do
    20
  end

  def rss(posts) do
    site = Application.fetch_env!(:ackurat, :site)

    XmlBuilder.element(:rss, %{version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"}, [
      {:channel,
       [
         {:title, site[:title]},
         {:link, site[:url]},
         {:description, "Recent content on #{site[:title]}"},
         {:language, "en-us"},
         {:copyright, site[:copyright]},
         {:lastBuildDate, format_rss_date(DateTime.utc_now())},
         {:"atom:link",
          %{
            href: "#{site[:url]}/index.xml",
            rel: "self",
            type: "application/rss+xml"
          }}
       ] ++
         for post <- Enum.take(posts, rss_post_limit()) do
           {:item,
            [
              {:title, post.title},
              {:link, site[:url] <> post.route},
              {:pubDate, format_rss_date(post.date)},
              {:author, site[:email]},
              {:guid, site[:url] <> post.route},
              {:description, strip_header_links(post.body)}
            ]}
         end}
    ])
    |> XmlBuilder.generate()
  end

  defp strip_header_links(body) do
    body
    |> Floki.parse_fragment!()
    |> Floki.traverse_and_update(fn
      {"html", _, [{"head", _, _}, {"body", _, children}]} ->
        children

      {"a", [{"href", "#" <> _}], node} ->
        {"span", [], node}

      node ->
        node
    end)
    |> Floki.raw_html()
  end
end
