defmodule WebsocketExample do
  alias PhoenixClient.{Socket, Channel, Message}

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_opts) do
    {:ok, _response, channel} = Channel.join(Socket, "updates:BTC-ETH")
    {:ok, %{channel: channel}}
  end

  # do some work, call `Channel.push` ...

  def handle_info(%Message{event: _, payload: payload}, state) do
    IO.puts "Incoming Message: #{inspect payload}"

    {:noreply, state}
  end
end
