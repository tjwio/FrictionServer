defmodule FrictionServerWeb.TokenController do
  use FrictionServerWeb, :controller

  alias FrictionServer.Notifications
  alias FrictionServer.Notifications.Token

  def add_token(conn, %{"udid" => udid} = params) do
    case Notifications.get_token_by_udid!(udid) do
      token ->
        update_token(conn, token, params)
      nil ->
        add_token_helper(conn, params)
    end
  end

  defp update_token(conn, token, params) do
    case Notifications.update_token(token, params) do
      {:ok, token} ->
        conn
        |> send_resp(200, Poison.encode!(token))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(changeset.errors))
    end
  end

  defp add_token_helper(conn, params) do
    case Notifications.create_token(params) do
      {:ok, token} ->
        conn
        |> send_resp(200, Poison.encode!(token))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(changeset.errors))
    end
  end

end
