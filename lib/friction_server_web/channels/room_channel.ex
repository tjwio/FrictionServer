defmodule FrictionServerWeb.RoomChannel do
  use FrictionServerWeb, :channel

  def join("room:lobby", payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    case FrictionServer.Clashes.create_message(payload) do
      {:ok, message} ->
        message = FrictionServer.Repo.preload(message, [:user, :claps, :dislikes])

        FrictionServer.Notifications.send_notification_to_users(FrictionServer.Clashes.Message.get_users_from_message(message.message),
          message.user.name ++ " just replied to you! " ++ message.message)

        broadcast socket, "shout", FrictionServer.Clashes.Message.map(message)
        {:noreply, socket}
      {:error, _error} ->
        {:reply, {:error, Poison.encode!(%{error: "bad message payload"})}, socket}
    end
  end
end
