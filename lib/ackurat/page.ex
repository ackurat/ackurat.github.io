defmodule Ackurat.Page do
  @moduledoc false

  @enforce_keys [
    :id,
    :title,
    :description,
    :body,
    :route
  ]

  defstruct [
    :id,
    :title,
    :body,
    :description,
    :date,
    :route
  ]

  def build(file_path, attrs, body) do
    id = Path.basename(Path.rootname(file_path))

    struct!(
      __MODULE__,
      [
        id: id,
        body: body,
        route: "/" <> id,
        date: DateTime.utc_now()
      ] ++
        Map.to_list(attrs)
    )
  end
end
