defmodule Ackurat.Render.Post do
  use Phoenix.Component
  alias Ackurat.Content
  import Ackurat.Render.Layout
  import Phoenix.HTML

  def format_post_date(date) do
    Calendar.strftime(date, "%b %-d, %Y")
  end

  def count_words(text) do
    text |> HtmlSanitizeEx.strip_tags() |> String.split() |> Enum.count()
  end

  def get_adjacent(id) do
    {prev, next} = Content.adjacent_posts(id)
    {prev, next}
  end

  def get_previous(id) do
    case Content.adjacent_posts(id) do
      {prev, _} -> prev
    end
  end

  def get_next(id) do
    case Content.adjacent_posts(id) do
      {_, next} -> next
    end
  end

  def post(assigns) do
    ~H"""
    <.layout
      title={"#{@title} — #{Content.site_title()}"}
      description={@description}
      og_type="article"
      route={@route}
      date={@date}
      keywords={@keywords}
      wordcount={count_words(@description <>" " <> @body)}
    >
      <div class="flex flex-col">
        <span class="text-base"><%= format_post_date(@date) %></span>
        <span class="text-3xl"><%= @title %></span>
        <div>
          <a class="text-base mr-2" :for={keyword <- @keywords} href={"/keywords/" <> keyword} class="text-base"><%= keyword %></a>
        </div>
      </div>
      <article class="text-l">
        <%= raw @body %>
      </article>
      <.footer>
        <div class="flex justify-between">
          <%= if get_previous(@id) != :nil do %>
            <a href={"/" <> get_previous(@id)}>
              Previous
            </a>
          <% end %>
          <%= if get_next(@id) != :nil do %>
            <a href={"/" <> get_next(@id)}>
              Next
            </a>
          <% end %>
        </div>
      </.footer>
      </.layout>
    """
  end
end
