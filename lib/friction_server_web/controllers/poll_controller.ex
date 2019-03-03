defmodule FrictionServerWeb.PollController do
  @moduledoc false

  require Logger

  use FrictionServerWeb, :controller

  alias FrictionServer.Clashes
  alias FrictionServer.Clashes.{Message, Poll, Option}

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

  def get_messages(conn, %{"id" => poll_id}) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)
    poll = Clashes.get_poll!(poll_id)
    messages = Clashes.get_messages(poll)

    conn
    |> send_resp(200, Poison.encode!(messages, [{:user_id, user.id}]))
  end

  def get_stats(conn, %{"id" => poll_id}) do
    poll = Clashes.get_poll!(poll_id)

    conn
    |> send_resp(200, Poison.encode!(Clashes.get_stats(poll)))
  end

  def create(conn, params) do
    case Clashes.create_poll(params) do
      {:ok, poll} ->
        poll = FrictionServer.Repo.preload(poll, [:options, options: :votes])

        FrictionServer.Notifications.send_notification_to_all("New poll! " <> poll.name)
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
        |> send_resp(400, Poison.encode!(message: "Failed to update poll"))
    end
  end

  def delete(conn, %{"id" => poll_id}) do
    poll = Clashes.get_poll!(poll_id)
    {:ok, _poll} = Clashes.delete_poll(poll)

    conn
    |> send_resp(200, Poison.encode!(%{message: "Success"}))
  end

  def add_vote(conn, params) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)

    case Clashes.create_vote(user, params) do
      {:ok, vote} ->
        conn
        |> send_resp(200, Poison.encode!(vote))
      {:error, _error} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create vote"}))
    end
  end

  def update_vote(conn, %{"id" => vote_id} = params) do
    vote = Clashes.get_vote!(vote_id)

    case Clashes.update_vote(vote, params) do
      {:ok, vote} ->
        conn
        |> send_resp(200, Poison.encode!(vote))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(message: "Failed to update vote"))
    end
  end

  def show_votes(conn, params) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)

    votes = Clashes.get_votes(user)

    conn
    |> send_resp(200, Poison.encode!(votes))
  end

end
