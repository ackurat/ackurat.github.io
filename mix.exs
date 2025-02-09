defmodule Ackurat.MixProject do
  use Mix.Project

  def project do
    [
      app: :ackurat,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      {:makeup_elixir, "~> 1.0.0"},
      {:makeup_js, "~> 0.1.0"},
      {:makeup_html, "~> 0.1.1"},
      {:makeup_sql, "~> 0.1.0"},
      {:phoenix_live_view, "~> 1.0.0"},
      {:xml_builder, "~> 2.3.0"},
      {:yaml_elixir, "~> 2.11.0"},
      {:html_sanitize_ex, "~> 1.4.3"},
      {:bandit, "~> 1.6.0", only: :dev},
      {:exsync, "~> 0.4", only: :dev},
      {:tailwind, "~> 0.2"}
    ]
  end
end
