defmodule FrictionServerWeb.MessageController do
  @moduledoc false

  alias FrictionServer.{Clashes, Repo}

  use FrictionServerWeb, :controller

  def add_claps(conn, %{"id" => message_id, "claps" => claps}) do
    message = Clashes.get_message!(message_id)

    case Clashes.update_message(message, %{claps: message.claps + claps}) do
      {:ok, message} ->
        message = Repo.preload(message, [:user])

        FrictionServer.Endpoint.broadcast("room:lobby", "claps", Clashes.Messages.map(message))

        conn
        |> send_resp(200, Poison.encode!(message))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(message: "Failed to update message"))
    end
  end

end
