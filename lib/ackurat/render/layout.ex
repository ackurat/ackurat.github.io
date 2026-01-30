defmodule Ackurat.Render.Layout do
  use Phoenix.Component
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
    site = Application.fetch_env!(:ackurat, :site)
    assigns = assign(assigns, :site, site)

    ~H"""
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title><%= if @title != "" do %>
              <%= @title %> @ <%= @site[:title] %>
            <% else %>
              <%= @site[:title] %>
            <% end %>
          </title>
          <meta name="description" content={@description} />
          <meta name="author" content={@site[:author]} />
          <meta http-equiv="X-UA-Compatible" content="IE=edge" />
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <link href="/index.xml" rel="alternate" type="application/rss+xml" title={@site[:title]} />
          <meta name="ROBOTS" content="INDEX, FOLLOW" />
          <meta property="og:title" content={@title} />
          <meta property="og:description" content={@description} />
          <meta property="og:type" content={@og_type} />
          <meta property="og:url" content={"#{@site[:url]}#{@route}"}>
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
            <meta property="article:author" content={@site[:author]} />
            <meta property="article:section" content="Software" />
            <meta :for={keyword <- @keywords} property="article:tag" content={keyword} />
            <meta property="article:published_time" content={format_iso_date(@date)} />
            <meta property="article:modified_time" content={format_iso_date(@date)} />
          <% end %>
          <link rel="canonical" href={"#{@site[:url]}#{@route}"} />
          <link rel="stylesheet" href="/style.css" />
          <script>
            (function() {
              const storedTheme = localStorage.getItem('theme');
              const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
              const theme = storedTheme || systemTheme;

              document.documentElement.style.colorScheme = theme;
              document.documentElement.classList.add(theme);

              const storedContrast = localStorage.getItem('highContrast') === 'true';
              const systemContrast = window.matchMedia('(prefers-contrast: more)').matches ? 'hc' : '';
              const contrast = storedContrast || systemContrast;
              if (contrast) {
                document.documentElement.classList.add('hc');
              }
            })();
          </script>
          <%= if Application.get_env(:ackurat, :env) == :prod do %>
            <script data-goatcounter="https://ackurat.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>
          <% end %>
        </head>
        <body class="bg-latte-crust dark:bg-macchiato-base hc:bg-white hc:dark:bg-black text-latte-text dark:text-macchiato-text hc:text-black hc:dark:text-white min-h-screen font-sans">
            <header class="flex justify-center py-4" id="top">
                <nav class="flex justify-between items-center gap-4 pb-6 px-2 text-lg font-bold tracking-wider w-full max-w-2xl">
                    <a href="/">~/</a>
                    <div class="flex flex-wrap gap-4">
                        <a href="/about">/about</a>
                        <a href="/archive">/archive</a>
                        <a type="application/rss+xml" href="/feed" alt="RSS feed" aria-label="RSS feed">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-[1em] w-auto inline-block align-middle -mt-0.5" viewBox="0 0 24 24" aria-label="RSS icon with radio waves emanating from a dot in the lower left">
                            <!-- Icon from Logos free icons by Streamline - https://creativecommons.org/licenses/by/4.0/ -->
                                <g fill="currentColor" stroke="none" stroke-linejoin="round">
                                    <path d="M1.5 19.5a3 3 0 1 0 6 0a3 3 0 1 0-6 0"/>
                                    <path d="M12.5 22.5c0-6.075-4.925-11-11-11v-3c7.732 0 14 6.268 14 14z" clip-rule="evenodd"/>
                                    <path d="M19.5 22.5c0-9.941-8.059-18-18-18v-3c11.598 0 21 9.402 21 21z" clip-rule="evenodd"/>
                                </g>
                            </svg>
                        </a>
                        <button id="theme-toggle" class="cursor-pointer hover:opacity-70 transition-opacity" aria-label="Toggle theme">
                            <span id="theme-icon"></span>
                        </button>
                        <button id="contrast-toggle" class="cursor-pointer hover:opacity-70 transition-opacity" aria-label="Toggle high contrast">
                            <span id="contrast-icon"></span>
                        </button>
                    </div>
                </nav>
            </header>
            <main class="w-full">
                <%= render_slot(@inner_block) %>
            </main>
            <script>
                const themeToggle = document.getElementById('theme-toggle');
                const themeIcon = document.getElementById('theme-icon');
                const contrastToggle = document.getElementById('contrast-toggle');
                const contrastIcon = document.getElementById('contrast-icon');
                const html = document.documentElement;

                function updateThemeIcon() {
                  const currentTheme = html.style.colorScheme ||
                      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
                  themeIcon.textContent = currentTheme === 'dark' ? '☼' : '☾';
                }

                function updateContrastIcon() {
                  const isHighContrast = html.classList.contains('hc');
                  contrastIcon.textContent = isHighContrast ? '◑' : '◐';
                }

                updateThemeIcon();
                updateContrastIcon();

                themeToggle.addEventListener('click', () => {
                  const currentTheme = html.style.colorScheme ||
                      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
                  const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                  html.style.colorScheme = newTheme;
                  html.classList.remove('light', 'dark');
                  html.classList.add(newTheme);
                  localStorage.setItem('theme', newTheme);
                  updateThemeIcon();
                });

                contrastToggle.addEventListener('click', () => {
                  const isHighContrast = html.classList.contains('hc');
                  if (isHighContrast) {
                    html.classList.remove('hc');
                    localStorage.setItem('highContrast', 'false');
                  } else {
                    html.classList.add('hc');
                    localStorage.setItem('highContrast', 'true');
                  }
                  updateContrastIcon();
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
      <div class="-mx-4 my-2 flex h-1 w-screen rounded-full sm:mx-0 sm:w-full bg-linear-to-r dark:from-footer-dark-1 from-footer-light-1 dark:via-footer-dark-2 via-footer-light-2 dark:to-footer-dark-3 to-footer-light-3"></div>
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
      title={@title}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="flex justify-center px-4">
        <div class="w-full max-w-2xl">
          <.heading>
            <a href={@route}><%= @title %></a>
          </.heading>
          <article class="text-l">
            <%= raw @body %>
          </article>
        </div>
      </div>
    </.layout>
    """
  end

  # TODO - prerender this on compilation
  def sitemap(pages) do
    site = Application.fetch_env!(:ackurat, :site)

    {:urlset,
     %{
       xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9",
       "xmlns:xhtml": "http://www.w3.org/1999/xhtml"
     },
     [
       {:url,
        [
          {:loc, site[:url]},
          {:lastmod, format_iso_date(DateTime.utc_now())}
        ]}
       | for page <- pages do
           {:url, [{:loc, site[:url] <> page.route}, {:lastmod, format_iso_date(page.date)}]}
         end
     ]}
    |> XmlBuilder.document()
    |> XmlBuilder.generate()
  end
end
