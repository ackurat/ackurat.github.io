import Config

config :tailwind,
  version: "3.4.17",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=../assets/css/input.css
      --output=../output/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :exsync,
  src_monitor: true,
  extra_extensions: [".md", ".js", ".css", ".yml"],
  addition_dirs: ["/pages", "/assets"]
