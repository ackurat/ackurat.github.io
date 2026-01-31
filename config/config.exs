import Config

config :ackurat, env: Mix.env()

config :tailwind,
  version: "4.1.18",
  default: [
    args: ~w(
      --input=priv/assets/input.css
      --output=priv/static/style.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

config :floki, :html_parser, Floki.HTMLParser.Html5ever

config :ackurat, :site,
  title: "dev.liliemark.se",
  description: "A personal website",
  author: "Adam CL",
  url: "https://dev.liliemark.se",
  email: "dev@liliemark.se",
  copyright:
    "This work is licensed under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International. To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-nd/4.0/"

import_config "#{config_env()}.exs"
