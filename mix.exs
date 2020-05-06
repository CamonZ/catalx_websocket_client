defmodule WebsocketExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :websocket_example,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :phoenix_client],
      mod: {WebsocketExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:phoenix_client, "~> 0.3"},
        {:websocket_client, "~> 1.3"},
        {:jason, "~> 1.0"}
      ]
  end
end
