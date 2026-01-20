defmodule Mix.Tasks.Ack.Post do
  use Mix.Task

  def run([file_name, keywords]) do
    app_dir = File.cwd!()

    current_datetime_utc = DateTime.utc_now()

    {:ok, current_date} =
      Date.new(current_datetime_utc.year, current_datetime_utc.month, current_datetime_utc.day)

    date = current_date |> Date.to_string()

    id =
      file_name
      |> String.downcase()
      |> String.replace(~r/[^a-z]+/, "-")
      |> String.trim("-")

    new_file_path = Path.join([app_dir, "pages", "posts", "#{date}-#{id}.dj"])

    keywords =
      keywords
      |> String.split(" ")
      |> Enum.map(&"\"#{&1}\"")
      |> Enum.join(", ")

    File.write(
      new_file_path,
      """
      %{
        title: "#{String.capitalize(file_name)}",
        description: "",
        keywords: [#{keywords}],
        draft: true,
      }

      ---


      """,
      [:write]
    )
  end
end
