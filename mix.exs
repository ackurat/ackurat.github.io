defmodule Ackurat.MixProject do
  use Mix.Project
  @app :ackurat

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        ackurat: [
          include_executables_for: [:unix]
        ]
      ]
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
      {:phoenix_live_view, "~> 1.1.20"},
      {:xml_builder, "~> 2.4.0"},
      {:html_sanitize_ex, "~> 1.4.4"},
      {:bandit, "~> 1.10.2"},
      {:exsync, "~> 0.4", only: :dev},
      {:tailwind, "~> 0.4.1"},
      {:djot, "~> 0.1.4"},
      {:lumis, "~> 0.1.0"},
      {:floki, "~> 0.38"},
      {:html5ever, "~> 0.16"}
    ]
  end
end
