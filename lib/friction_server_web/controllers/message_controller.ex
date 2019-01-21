defmodule FrictionServerWeb.MessageController do
  @moduledoc false

  alias FrictionServer.{Clashes, Repo}

  use FrictionServerWeb, :controller

  def add_claps(conn, %{"id" => message_id, "claps" => claps} = attrs) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)
    message = Clashes.get_message!(message_id)

    case Clashes.create_clap(user, %{claps: claps, message_id: message_id}) do
      {:ok, clap} ->
        message = Repo.preload(message, [:user, :claps, :dislikes])

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
        message = Repo.preload(message, [:user, :claps, :dislikes])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "claps", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(clap))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to update claps"}))
    end
  end

  def add_dislikes(conn, %{"id" => message_id, "dislikes" => dislikes} = attrs) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)
    message = Clashes.get_message!(message_id)

    case Clashes.create_dislike(user, %{dislikes: dislikes, message_id: message_id}) do
      {:ok, dislike} ->
        message = Repo.preload(message, [:user, :claps, :dislikes])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "dislikes", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(dislike))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to add dislikes"}))
    end
  end

  def update_dislikes(conn, %{"message_id" => message_id, "dislike_id" => dislike_id, "dislikes" => dislikes} = attrs) do
    dislike = Clashes.get_dislike!(dislike_id)
    message = Clashes.get_message!(message_id)

    case Clashes.update_dislike(dislike, %{dislikes: dislike.dislikes + dislikes}) do
      {:ok, dislike} ->
        message = Repo.preload(message, [:user, :claps, :dislikes])

        FrictionServerWeb.Endpoint.broadcast("room:lobby", "dislikes", Clashes.Message.map(message))

        conn
        |> send_resp(200, Poison.encode!(dislike))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to update dislikes"}))
    end
  end
end
