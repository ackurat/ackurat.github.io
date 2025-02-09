defmodule Ackurat.Processor do
  @moduledoc """
  Custom Earmark processor to add ids to H2 elements
  """

  def process({"h2", [], [text], %{}}) do
    case text do
      {_, [{_, anchor_id}], _, _} -> {"h2", [{"id", anchor_id |> String.trim("#")}], [text], %{}}
      _ -> {"h2", [], [text], %{}}
    end
  end

  def process(value), do: value
end
