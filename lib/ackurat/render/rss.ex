defmodule Ackurat.Render.Rss do
  alias Ackurat.Content

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
    XmlBuilder.element(:rss, %{version: "2.0", "xmlns:atom": "http://www.w3.org/2005/Atom"}, [
      {:channel,
       [
         {:title, Content.site_title()},
         {:link, Content.site_url()},
         {:description, "Recent content on #{Content.site_title()}"},
         {:language, "en-us"},
         {:managingEditor, "#{Content.site_author()} (#{Content.site_email()})"},
         {:webMaster, "#{Content.site_author()} (#{Content.site_email()})"},
         {:copyright, Content.site_copyright()},
         {:lastBuildDate, format_rss_date(DateTime.utc_now())},
         {:"atom:link",
          %{href: "#{Content.site_url()}/index.xml", rel: "self", type: "application/rss+xml"}}
       ] ++
         for post <- Enum.take(posts, rss_post_limit()) do
           {:item,
            [
              {:title, post.title},
              {:link, Content.site_url() <> post.route},
              {:pubDate, format_rss_date(post.date)},
              {:author, "#{Content.site_author()} (#{Content.site_email()})"},
              {:guid, Content.site_url() <> post.route},
              {:description, post.body}
            ]}
         end}
    ])
    |> XmlBuilder.generate()
  end
end
