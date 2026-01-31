import Config

config :exsync,
  src_monitor: true,
  extra_extensions: [".md", ".js", ".css", ".yml", ".dj"],
  addition_dirs: ["/priv/pages", "/priv/posts", "/priv/assets"],
  reload_callback: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
