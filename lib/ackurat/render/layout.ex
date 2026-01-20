defmodule Ackurat.Render.Layout do
  use Phoenix.Component
  alias Ackurat.Content
  import Phoenix.HTML

  def format_iso_date(date = %DateTime{}) do
    DateTime.to_iso8601(date)
  end

  def format_iso_date(date = %Date{}) do
    date
    |> DateTime.new!(~T[06:00:00])
    |> format_iso_date()
  end

  def layout(assigns) do
    ~H"""
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title><%= @title %></title>
          <meta name="description" content={@description} />
          <meta name="author" content={Content.site_author()} />
          <meta http-equiv="X-UA-Compatible" content="IE=edge" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link href="/index.xml" rel="alternate" type="application/rss+xml" title={Content.site_title()} />
          <meta name="ROBOTS" content="INDEX, FOLLOW" />
          <meta property="og:title" content={@title} />
          <meta property="og:description" content={@description} />
          <meta property="og:type" content={@og_type} />
          <meta property="og:url" content={"#{Content.site_url()}#{@route}"}>
          <meta name="twitter:card" content="summary" />
          <meta name="twitter:title" content={@title} />
          <meta name="twitter:description" content={@description} />
          <meta itemprop="name" content={@title} />
          <meta itemprop="description" content={@description} />
          <%= if @og_type == "article" do %>
            <meta itemprop="datePublished" content={format_iso_date(@date)} />
            <meta itemprop="dateModified" content={format_iso_date(@date)} />
            <meta itemprop="wordCount" content={@wordcount} />
            <meta itemprop="keywords" content={Enum.join(@keywords, ",")} />
            <meta property="article:author" content={Content.site_author()} />
            <meta property="article:section" content="Software" />
            <meta :for={keyword <- @keywords} property="article:tag" content={keyword} />
            <meta property="article:published_time" content={format_iso_date(@date)} />
            <meta property="article:modified_time" content={format_iso_date(@date)} />
          <% end %>
          <link rel="canonical" href={"#{Content.site_url()}#{@route}"} />
          <link rel="stylesheet" href="/assets/app.css" />
          <script>
            (function() {
            const theme = localStorage.getItem('theme') ||
                (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', theme);
            })();
          </script>
          <%= if MIX_ENV == "prod" do %>
            <script data-goatcounter="https://ackurat.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>
          <% end %>
        </head>
        <body>
            <header class="flex justify-center py-4">
                <nav class="flex flex-wrap justify-center gap-4 pb-6 px-2 text-lg font-bold tracking-wider max-w-2xl">
                    <a href="/">Home</a>
                    <a href="/about/">About</a>
                    <a href="/archive/">Archive</a>
                    <a type="application/rss+xml" href="/index.xml">RSS</a>
                    <button id="theme-toggle" class="cursor-pointer hover:opacity-70 transition-opacity" aria-label="Toggle theme">
                        <span id="theme-icon"></span>
                    </button>
                </nav>
            </header>
            <main class="w-full">
                <%= render_slot(@inner_block) %>
            </main>
            <script>
                const themeToggle = document.getElementById('theme-toggle');
                const themeIcon = document.getElementById('theme-icon');
                const html = document.documentElement;

                function updateIcon() {
                  const currentTheme = html.getAttribute('data-theme');
                  themeIcon.textContent = currentTheme === 'dark' ? '☼' : '☾';
                }

                updateIcon();

                themeToggle.addEventListener('click', () => {
                  const currentTheme = html.getAttribute('data-theme');
                  const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                  html.setAttribute('data-theme', newTheme);
                  localStorage.setItem('theme', newTheme);
                  updateIcon();
                });
            </script>
        </body>
      </html>
    """
  end

  def heading(assigns) do
    ~H"""
    <span class="text-3xl my-4"><%= render_slot(@inner_block) %></span>
    """
  end

  def footer(assigns) do
    ~H"""
      <div class="-mx-4 my-2 flex h-1 w-[100vw] bg-gradient-to-r from-[rgb(244,219,214)] to-[rgb(198,160,246)] dark:from-[rgb(237,135,150)] dark:to-[rgb(238,212,159)] sm:mx-0 sm:w-full"></div>
      <footer class="italic">
        <%= render_slot(@inner_block) %>
      </footer>
    """
  end

  def centered_content(assigns) do
    ~H"""
    <div class="flex justify-center px-4">
      <div class="w-full max-w-2xl">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def page(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{Content.site_title()}"}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="flex justify-center px-4">
        <div class="w-full max-w-2xl">
          <.heading>
            <a href={@route}><%= @title %></a>
          </.heading>
          <article class="text-xl">
            <%= raw @body %>
          </article>
        </div>
      </div>
    </.layout>
    """
  end

  def sitemap(pages) do
    {:urlset,
     %{
       xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9",
       "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
     },
     [
       {:url, [{:loc, Content.site_url()}, {:lastmod, format_iso_date(DateTime.utc_now())}]}
       | for page <- pages do
           {:url,
            [{:loc, Content.site_url() <> page.route}, {:lastmod, format_iso_date(page.date)}]}
         end
     ]}
    |> XmlBuilder.document()
    |> XmlBuilder.generate()
  end

  def redirect(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en-us">
      <head>
        <title><%= @target%></title>
        <link rel="canonical" href={@target}>
        <meta name="robots" content="noindex">
        <meta charset="utf-8">
        <meta http-equiv="refresh" content={"0; url=#{@target}"}>
      </head>
    </html>
    """
  end
end
