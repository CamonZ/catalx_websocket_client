defmodule WebsocketExample.UserDataClient do
  alias PhoenixClient.{Socket, Channel, Message}

  @endpoint "wss://api.catalyx.io/socket/websocket"

  @api_key "API_KEY"
  @api_secret "API_SECRET"

  defstruct socket_pid: nil, channel_pid: nil, channel: nil

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(opts) do
    endpoint = Keyword.get(opts, :endpoint, @endpoint)
    channel = Keyword.get(opts, :channel, @channel)

    %{url: url, signature: sig} = connection_url(endpoint)

    socket_opts = [url: url]

    {:ok, socket} = Socket.start_link(socket_opts)

    state = %__MODULE__{
      socket_pid: socket,
      channel: "users:#{sig}"
    }

    {:ok, state, {:continue, :join_channel}}
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

  def connection_url(endpoint) do
    %{timestamp: ts, signature: sig} = build_signature()

    parts = [
      api_key: @api_key,
      timestamp: ts,
      signature: sig
    ]

    qs = Enum.map(parts, fn {k, v} -> "#{k}=#{v}" end) |> Enum.join("&")

    %{url: "#{endpoint}?#{qs}", signature: sig}
  end

  defp build_signature do
    ts = System.os_time(:millisecond)
    parts = [ts, "AUTH", @api_key]

    signature =
      :sha512
      |> :crypto.hmac(@api_secret, Enum.join(parts, ""))
      |> Base.encode16(case: :lower)

    %{timestamp: ts, signature: signature}
  end
end
