defmodule Ackurat.Parser do
  @moduledoc """
  Custom Nimble Publisher parser to replace headings with linked headings
  """

  def parse(path, contents) do
     with {:ok, attrs, body} <- split(path, contents) do
       {updated_body, toc} =
         body
         |> String.split("\n\n")
         |> Enum.map_reduce([], fn line, acc ->
           case replace_heading(line) do
             {updated_line, nil} -> {updated_line, acc}
             {updated_line, toc_item} -> {updated_line, [toc_item | acc]}
           end
         end)

       updated_body = Enum.join(updated_body, "\n\n")
       attrs_with_toc = Map.put(attrs, :toc, Enum.reverse(toc))

       {attrs_with_toc, updated_body}
     end
   end

   defp replace_heading(line) do
     case Regex.run(~r/^(\#{1,6})\s+(.+)$/, line) do
       [_full, hashes, title] ->
         level = String.length(hashes)

         slug =
           title
           |> String.replace(~r/\s+/, "-")
           |> String.trim("-")

         updated_line = "#{hashes} [#{title}](##{slug})"

         # Only include h2, h3, h4 in TOC (not h1, h5, h6)
         toc_item = if level in [2, 3, 4] do
           %{level: level, text: title, id: slug}
         else
           nil
         end

         {updated_line, toc_item}

       nil ->
         {line, nil}
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
