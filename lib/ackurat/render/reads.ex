defmodule Ackurat.Render.Reads do
  use Phoenix.Component
  alias Ackurat.Content
  import Ackurat.Render.Layout

  def index(assigns) do
    ~H"""
    <.layout
      title="Reads"
      description="A list of articles I read and recommend."
      og_type="website"
      route="/reads/"
    >
      <.heading>
        Reads
      </.heading>
      <section>
        <a :for={page <- @pages} href={page.route}>
          <div class="mt-4">
            <div class="text-xl font-bold"><%= page.title %></div>
            <span class="text-base">Last updated <%= page.update %></span>
          </div>
        </a>
      </section>
    </.layout>
    """
  end

  def reads(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{Content.site_title()}"}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="mb-8">
        <h1 class="text-3xl font-bold mb-4"><%= @title %></h1>
        <p class="text-lg mb-6"><%= @description %></p>
      </div>

      <article class="space-y-6">
        <ul class="space-y-6 list-none">
          <li :for={link <- @links} class="group">
            <div class="flex items-start space-x-3 mb-2">
              <img
                src={"https://www.google.com/s2/favicons?domain=#{ URI.parse(link["url"]).host }"}
                class="w-4 h-4 mt-1.5"
                alt=""
              />
              <div class="flex-1">
                <a
                  href={link["url"]}
                  rel="nofollow"
                  class="text-lg font-medium transition-colors duration-200"
                >
                  <%= link["title"] %>
                </a>
                <%= if link["description"] do %>
                  <p class="mt-1 leading-relaxed">
                    <%= link["description"] %>
                  </p>
                <% end %>
              </div>
            </div>
          </li>
        </ul>
      </article>

      <footer class="mt-12 text-center">
      </footer>
    </.layout>
    """
  end
end
