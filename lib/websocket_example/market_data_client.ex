defmodule WebsocketExample.MarketDataClient do
  alias PhoenixClient.{Socket, Channel, Message}

  @endpoint "wss://api.catalyx.io/markets/websocket"
  @channel "updates:BTC-CAD"
  defstruct socket_pid: nil, channel_pid: nil, channel: nil

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, endpoint: @endpoint, channel: @channel)
  end

  def init(opts) do
    endpoint = Keyword.get(opts, :endpoint, @endpoint)
    channel = Keyword.get(opts, :channel, @channel)

    socket_opts = [url: endpoint]

    {:ok, socket} = Socket.start_link(socket_opts)
    {:ok, %__MODULE__{socket_pid: socket, channel: channel}, {:continue, :join_channel}}
  end

  def handle_continue(:join_channel, state) do
    case Channel.join(state.socket_pid, state.channel) do
      {:ok, _, channel} ->
        Logger.info("Joined channel: #{state.channel}")
        {:noreply, %{state | channel_pid: channel}}

      _ ->
        Process.send_after(self(), :retry_channel_join, 1000)
        {:noreply, state}
    end
  end

  def handle_info(%Message{event: _, payload: payload}, state) do
    IO.puts("Incoming Message: #{inspect(payload)}")

    {:noreply, state}
  end

  def handle_info(:retry_channel_join, state) do
    {:noreply, state, {:continue, :join_channel}}
  end

  def handle_info(message, state) do
    Logger.warn("Received unrecognized message: #{inspect(message)}")
    {:noreply, state}
  end
end
