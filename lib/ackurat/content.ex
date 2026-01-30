defmodule Ackurat.Content do
  def posts, do: Ackurat.Posts.active_posts()
  def pages, do: Ackurat.Pages.pages()

  def content, do: pages() ++ posts()
end
