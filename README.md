# WebsocketExample

Simple websocket examples to connect to catalyx exchange

## Running it

With an elixir version installed run `mix deps.get`, then `mix compile` to fetch dependencies and compile the project.

Once that's setup run the REPL with `iex -S mix`

In the REPL spawn one of the websocket clients via:

```elixir
{:ok, pid} = WebsocketExample.MarketDataClient.start_link
```

or alternatively add you API key and secret in `user_data_client.ex` then spawn that client via

```elixir
{:ok, pid} = WebsocketExample.UserDataClient.start_link
```
