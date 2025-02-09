defmodule Ackurat.Render.Reads do
  use Phoenix.Component
  alias Ackurat.Content
  import Ackurat.Render.Layout

  def reads(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{Content.site_title()}"}
      description={@description}
      og_type="website"
      route={@route}
    >
      <div class="post-header">
        <a href={@route}>
          <h1><%= @title %></h1>
        </a>
      </div>
      <article class="post-content">
        <p><%= @description %></p>
        <ul class="hide-list">
          <li :for={link <- @links}>
            <a href={ link["url"] } rel="nofollow">
              <img src={"https://www.google.com/s2/favicons?domain=#{ URI.parse(link["url"]).host }"} />
              <%= link["title"] %>
            </a>
          </li>
         </ul>
      </article>
        <footer>
          footer
        </footer>
    </.layout>
    """
  end
end
