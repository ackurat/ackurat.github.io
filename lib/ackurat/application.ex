defmodule Ackurat.Application do
  require Logger
  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        {Bandit, plug: Ackurat.Router, scheme: :http}
      ]

    opts = [strategy: :one_for_one, name: Ackurat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
