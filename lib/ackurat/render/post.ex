defmodule Ackurat.Render.Post do
  use Phoenix.Component
  alias Ackurat.Posts
  import Ackurat.Render.Layout
  import Phoenix.HTML

  def format_post_date(date) do
    Calendar.strftime(date, "%b %-d, %Y")
  end

  def count_words(text) do
    text |> HtmlSanitizeEx.strip_tags() |> String.split() |> Enum.count()
  end

  def get_adjacent(id) do
    {prev, next} = Posts.adjacent_posts(id)
    {prev, next}
  end

  def get_previous(id) do
    case Posts.adjacent_posts(id) do
      {prev, _} -> prev
    end
  end

  def get_next(id) do
    case Posts.adjacent_posts(id) do
      {_, next} -> next
    end
  end

  defp table_of_contents(assigns) do
    ~H"""
    <%= if @toc != [] do %>
      <aside class="hidden lg:block fixed left-[calc(50%-624px)] w-64" style="top: calc(5rem + 6.5rem);">
        <nav class="sticky top-4">
          <ol class="list-none space-y-2 text-sm pl-0">
            <li class="ml-0">
                <a href="#top" alt="Scroll to top" aria-label="Scroll to top">
                  <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" aria-label="Icon showing an arrow pointing upwards, enclosed in a circle">
                    <!-- Icon from Material Symbols by Google - https://github.com/google/material-design-icons/blob/master/LICENSE -->
                    <path fill="currentColor" d="M11 16h2v-4.2l1.6 1.6L16 12l-4-4l-4 4l1.4 1.4l1.6-1.6zm1 6q-2.075 0-3.9-.788t-3.175-2.137T2.788 15.9T2 12t.788-3.9t2.137-3.175T8.1 2.788T12 2t3.9.788t3.175 2.137T21.213 8.1T22 12t-.788 3.9t-2.137 3.175t-3.175 2.138T12 22"/>
                  </svg>
                </a>
            </li>
            <%= for item <- @toc do %>
              <li class={[
                "leading-relaxed",
                item.level == 2 && "ml-0",
                item.level == 3 && "ml-3",
                item.level == 4 && "ml-6"
              ]}>
                <a
                  href={"##{item.id}"}
                  data-toc-link={item.id}
                  class="no-underline opacity-80 hover:opacity-100 hover:text-[rgb(30,102,245)] dark:hover:text-[rgb(138,173,244)] transition-opacity block py-1 [&[data-active='true']]:opacity-100 [&[data-active='true']]:font-bold"
                >
                  <%= item.text %>
                </a>
              </li>
            <% end %>
          </ol>
        </nav>
      </aside>
    <% end %>
    """
  end

  defp section_tracker(assigns) do
    ~H"""
    <script>
      (function() {
        let lastHash = location.hash;

        function updateTOC(sectionId) {
          document.querySelectorAll('[data-toc-link]').forEach(function(link) {
            link.setAttribute('data-active', link.dataset.tocLink === sectionId);
          });
        }

        document.addEventListener('scroll', function() {
          const sections = document.querySelectorAll('h1[id], h2[id], h3[id], h4[id], h5[id], h6[id], section[id]');
          let currentSection = null;

          sections.forEach(function(section) {
            if (window.scrollY >= section.offsetTop - 100) {
              currentSection = section;
            }
          });

          // If at bottom of page, use the last section
          if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 10) {
            currentSection = sections[sections.length - 1];
          }

          if (currentSection && currentSection.id) {
            const newHash = '#' + currentSection.id;
            if (lastHash !== newHash) {
              history.replaceState(null, '', location.origin + location.pathname + newHash);
              lastHash = newHash;
              updateTOC(currentSection.id);
            }
          }
        });

        if (location.hash) {
          updateTOC(decodeURIComponent(location.hash.substring(1)));
        }
      })();
    </script>
    """
  end

  def post(assigns) do
    ~H"""
    <.layout
      title={@title}
      description={@description}
      og_type="article"
      route={@route}
      date={@date}
      keywords={@keywords}
      wordcount={count_words(@description <>" " <> @body)}
    >
      <.table_of_contents toc={Map.get(assigns, :toc, [])} />

      <.centered_content>
        <article class="text-l">
          <div class="flex flex-col mb-6">
            <span class="text-base"><%= format_post_date(@date) %></span>
            <h1 class="text-3xl"><%= @title %></h1>
            <div>
              <a class="text-base mr-2" :for={keyword <- @keywords} href={"/keywords/" <> keyword}><%= keyword %></a>
            </div>
          </div>

          <%= raw @body %>
        </article>

        <.footer>
          <div class="flex justify-between">
            <%= if get_previous(@id) != :nil do %>
              <a href={"/posts/" <> get_previous(@id)}>
                Previous
              </a>
            <% end %>
            <%= if get_next(@id) != :nil do %>
              <a href={"/posts/" <> get_next(@id)}>
                Next
              </a>
            <% end %>
          </div>
        </.footer>
      </.centered_content>

      <.section_tracker/>
    </.layout>
    """
  end
end
