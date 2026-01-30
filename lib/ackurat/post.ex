defmodule Ackurat.Post do
  @enforce_keys [
    :id,
    :type,
    :title,
    :description,
    :body,
    :route
  ]

  defstruct [
    :id,
    :type,
    :title,
    :body,
    :description,
    :date,
    :route,
    :keywords,
    :archive,
    :draft,
    :toc
  ]

  def build(filename, attrs, body) do
    [slug] = filename |> Path.rootname() |> Path.split() |> Enum.take(-1)
    [year, month, day, id] = String.split(slug, "-", parts: 4)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    struct!(
      __MODULE__,
      [
        id: id,
        type: :post,
        date: date,
        body: body,
        route: "/posts/" <> id
      ] ++
        Map.to_list(attrs)
    )
  end
end
