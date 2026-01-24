import Config

config :tailwind,
  version: "4.1.18",
  default: [
    args: ~w(
      --input=assets/css/input.css
      --output=output/assets/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :exsync,
  src_monitor: true,
  extra_extensions: [".md", ".js", ".css", ".yml", ".dj"],
  addition_dirs: ["/pages", "/assets"]

config :floki, :html_parser, Floki.HTMLParser.Html5ever
