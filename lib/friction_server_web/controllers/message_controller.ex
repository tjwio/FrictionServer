defmodule FrictionServerWeb.MessageController do
  @moduledoc false

  alias FrictionServer.{Clashes, Repo}

  use FrictionServerWeb, :controller

  def add_claps(conn, %{"id" => message_id, "claps" => claps} = attrs) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)
    message = Clashes.get_message!(message_id)

    case Clashes.create_clap(user, %{claps: claps, message_id: message_id}) do
      {:ok, clap} ->
        message = Repo.preload(message, [:user, :claps])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "claps", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(clap))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to add claps"}))
    end
  end

  def update_claps(conn, %{"message_id" => message_id, "clap_id" => clap_id, "claps" => claps} = attrs) do
    clap = Clashes.get_clap!(clap_id)
    message = Clashes.get_message!(message_id)

    case Clashes.update_clap(clap, %{claps: clap.claps + claps}) do
      {:ok, clap} ->
        message = Repo.preload(message, [:user, :claps])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "claps", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(clap))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to add claps"}))
    end
  end

  def add_dislikes(conn, %{"id" => message_id, "dislikes" => dislikes}) do
    message = Clashes.get_message!(message_id)

    case Clashes.update_message(message, %{dislikes: (message.dislikes || 0) + dislikes}) do
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
