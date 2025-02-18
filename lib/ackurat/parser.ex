defmodule Ackurat.Parser do
  @moduledoc """
  Custom Nimble Publisher parser to replace headings with linked headings
  """

  def parse(path, contents) do
    with {:ok, attrs, body} <- split(path, contents) do
      updated_body =
        body
        |> String.split("\n\n")
        |> Enum.map(&replace_heading/1)
        |> Enum.join("\n\n")

      {attrs, updated_body}
    end
  end

  defp replace_heading(line) do
    if String.starts_with?(line, "## ") do
      title = String.replace(line, "## ", "")
      slug =
        title
        |> String.replace(~r/\s+/, "-")
        |> String.trim("-")

      "## [#{title}](##{slug})"
    else
      line
    end
  end

  defp split(path, contents) do
    case :binary.split(contents, ["\n---\n", "\r\n---\r\n"]) do
      [_] ->
        {:error, "could not find separator --- in #{inspect(path)}"}

      [code, body] ->
        case Code.eval_string(code, []) do
          {%{} = attrs, _} ->
            {:ok, attrs, body}

          {other, _} ->
            {:error,
              "expected attributes for #{inspect(path)} to return a map, got: #{inspect(other)}"}
        end
    end
  end
end
