defmodule Ackurat.Render.Photos do
  use Phoenix.Component
  alias Ackurat.Content
  import Ackurat.Render.Layout

  def index(assigns) do
    ~H"""
    <.layout title={"Photos — #{Content.site_title()}"} description={@description} og_type="gallery" route={@route}>
      <div class="max-w-screen-lg mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-6">
          <%= for {photo, index} <- Enum.with_index(@images) do %>
            <% meta = photo["meta"] %>
            <div class="group relative overflow-hidden rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300">
              <button
                type="button"
                onclick={"document.getElementById('modal-#{index}').classList.remove('hidden')"}
                class="w-full h-full cursor-pointer focus:outline-none"
              >
                <img
                  src={"/images/" <> photo["img"]}
                  alt=""
                  class="h-full object-cover transform transition-transform duration-300 group-hover:scale-105"
                  loading="lazy"
                />
                <%= if photo["title"] do %>
                  <div class="absolute bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                    <p class="text-sm"><%= photo["title"] %></p>
                  </div>
                <% end %>
              </button>
            </div>

            <!-- Modal for each image -->
            <div
              id={"modal-#{index}"}
              class="hidden fixed inset-0 z-50 overflow-auto bg-black bg-opacity-50 p-4 cursor-pointer"
              onclick={"document.getElementById('modal-#{index}').classList.add('hidden')"}
            >
              <div class="flex items-center justify-center min-h-screen">
                <div class="relative">
                  <button
                    type="button"
                    class="absolute top-4 right-4 text-white hover:text-gray-300"
                    onclick={"document.getElementById('modal-#{index}').classList.add('hidden')"}
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                  <img
                    src={"/images/" <> photo["img"]}
                    alt=""
                    class="max-w-full max-h-[90vh] object-contain"
                  />
                  <%= if meta do %>
                    <div class="relative bottom-0 left-0 right-0 bg-black bg-opacity-50 text-white p-4">
                      <p class="text-lg text-center"><%= meta["description"] %></p>
                      <div class="flex justify-between">
                        <span class="text-lg text-right"><%= meta["location"] %></span>
                        <span class="text-lg text-left"><%= meta["date"] %></span>
                      </div>
                      <%= if meta["camera"] do %>
                        <div class="flex justify-between text-sm">
                          <div>
                            <span class="text-left"><%= meta["camera"] %></span>
                            <%= if meta["lens"] do %>
                              <span class="text-left">&nbsp;with <%= meta["lens"] %></span>
                            <% end %>
                          </div>
                          <div>
                            <%= if meta["settings"] do %>
                              <span class="text-right"><%= Enum.join(meta["settings"], ", ") %></span>
                            <% end %>
                          </div>
                        </div>
                      <% end %>
                    </div>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        </div>

        <.footer>
          © 2025 Adam Liliemark
        </.footer>
      </div>
    </.layout>
    """
  end
end
