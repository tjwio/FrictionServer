defmodule FrictionServerWeb.MessageController do
  @moduledoc false

  alias FrictionServer.{Clashes, Repo}

  use FrictionServerWeb, :controller

  def add_claps(conn, %{"id" => message_id, "claps" => claps}) do
    message = Clashes.get_message!(message_id)

    case Clashes.update_message(message, %{claps: message.claps + claps}) do
      {:ok, message} ->
        message = Repo.preload(message, [:user])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "claps", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(message))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(message: "Failed to update message"))
    end
  end

  def add_dislikes(conn, %{"id" => message_id, "dislikes" => dislikes}) do
    message = Clashes.get_message!(message_id)

    dislikes = case message.dislikes do
      nil ->
        0
      downclaps ->
        downclaps
    end

    case Clashes.update_message(message, %{dislikes: dislikes + dislikes}) do
      {:ok, message} ->
        message = Repo.preload(message, [:user])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "dislikes", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(message))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(message: "Failed to update message"))
    end
  end

end
