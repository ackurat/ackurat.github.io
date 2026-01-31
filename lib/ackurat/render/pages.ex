defmodule Ackurat.Render.Pages do
  use Phoenix.Component
  alias Ackurat.Posts
  import Ackurat.Render.Layout
  import Ackurat.Render.Post

  def index(assigns) do
    ~H"""
    <.layout
      title={""}
      description={""}
      route="/"
      og_type="website"
    >
      <.centered_content>
        <.heading>Recent posts</.heading>
        <div>
          <a :for={post <- @posts} href={post.route}>
            <div class="mt-4">
              <div class="text-base"><%= format_post_date(post.date) %></div>
              <h2 class="text-xl font-bold"><%= post.title %></h2>
              <div class="text-lg"><%= post.description %></div>
            </div>
          </a>
        </div>
        <.footer>
          <p><center><i>Find more posts in the <a href="/archive/">archive</a></i></center></p>
        </.footer>
      </.centered_content>
    </.layout>
    """
  end

  def keyword(assigns) do
    ~H"""
    <.layout
      title={""}
      description={""}
      route="/"
      og_type="website"
    >
      <.centered_content>
        <.heading><%= assigns %></.heading>
        <div>
          <a :for={post <- Posts.posts_by_keyword(assigns)} href={post.route}>
            <div class="mt-4">
              <span class="text-base"><%= format_post_date(post.date) %></span>
              <div class="text-xl font-bold"><%= post.title %></div>
            </div>
          </a>
        </div>
      </.centered_content>
    </.layout>
    """
  end

  def archive(assigns) do
    ~H"""
    <.layout
      title={"Archive"}
      description={}
      route="/"
      og_type="website"
    >
      <.centered_content>
        <.heading>Tags</.heading>
        <section>
            <div class="mt-4 mb-4">
                <a class="text-base mr-2" :for={keyword <- @tags} href={"/keywords/" <> keyword}><%= keyword %></a>
            </div>
        </section>
        <.heading>Archive</.heading>
        <section>
          <a :for={post <- @posts} href={post.route}>
            <div class="mt-4">
              <span class="text-base"><%= format_post_date(post.date) %></span>
              <div class="text-xl font-bold"><%= post.title %></div>
            </div>
          </a>
        </section>
      </.centered_content>
    </.layout>
    """
  end
end
