defmodule FrictionServerWeb.PollController do
  @moduledoc false

  use FrictionServerWeb, :controller

  alias FrictionServer.Clashes
  alias FrictionServer.Clashes.{Poll, Option}

  def show(conn, %{"id" => poll_id}) do
    poll = Clashes.get_poll!(poll_id)

    conn
    |> send_resp(200, Poison.encode!(poll))
  end

  def show_all(conn, _params) do
    polls = Clashes.list_polls

    conn
    |> send_resp(200, Poison.encode!(polls))
  end

  def show_latest(conn, _params) do
    poll = Clashes.get_latest_poll!

    conn
    |> send_resp(200, Poison.encode!(poll))
  end

  def create(conn, params) do
    case Clashes.create_poll(params) do
      {:ok, poll} ->
        conn
        |> send_resp(200, Poison.encode!(poll))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create poll"}))
    end
  end

  def update(conn, %{"id" => poll_id} = params) do
    poll = Clashes.get_poll!(poll_id)

    case Clashes.update_poll(poll, params) do
      {:ok, poll} ->
        conn
        |> send_resp(200, Poison.encode!(poll))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode(message: "Failed to update poll"))
    end
  end

  def delete(conn, %{"id" => poll_id}) do
    poll = Clashes.get_poll!(poll_id)
    {:ok, _poll} = Clashes.delete_poll(poll)

    conn
    |> send_resp(200, Poison.encode!(%{message: "Success"}))
  end

end
