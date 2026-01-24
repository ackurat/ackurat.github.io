defmodule Ackurat.MixProject do
  use Mix.Project
  @app :ackurat

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Ackurat.Application, []}
    ]
  end

  defp deps do
    [
      {:nimble_publisher, "~> 1.1.0"},
      {:phoenix_live_view, "~> 1.1.5"},
      {:xml_builder, "~> 2.4.0"},
      {:yaml_elixir, "~> 2.12.0"},
      {:html_sanitize_ex, "~> 1.4.3"},
      {:bandit, "~> 1.8.0", only: :dev},
      {:exsync, "~> 0.4", only: :dev},
      {:tailwind, "~> 0.2"},
      {:djot, "~> 0.1.4"},
      {:autumn, "~> 0.6.0"},
      {:floki, "~> 0.38"},
      {:html5ever, "~> 0.16"}
    ]
  end
end
