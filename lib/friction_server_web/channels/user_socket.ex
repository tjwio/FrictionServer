defmodule FrictionServerWeb.UserSocket do
  use Phoenix.Socket

  require Logger

  ## Channels
   channel "room:lobby", FrictionServerWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket,
            websocket: [timeout: 45_000],
            longpoll: false
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Guardian.Phoenix.Socket.authenticate(socket, FrictionServer.Authentication.Guardian, token) do
      {:ok, authed_socket} ->
        {:ok, authed_socket}
      {:error, _error} ->
        :error
    end
  end

  def connect(_params, _socket) do
    :error
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     FrictionServerWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
