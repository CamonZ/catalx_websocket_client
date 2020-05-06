defmodule WebsocketExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    socket_opts = [url: "wss://api.catalx.io/markets/websocket"]


    children = [
      {PhoenixClient.Socket, {socket_opts, name: PhoenixClient.Socket}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WebsocketExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
