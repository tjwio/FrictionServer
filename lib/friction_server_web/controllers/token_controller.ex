defmodule FrictionServerWeb.TokenController do
  use FrictionServerWeb, :controller

  alias FrictionServer.Notifications
  alias FrictionServer.Notifications.Token

  def add_token(conn, %{"token" => token, "user_id" => user_id} = params) do
    case Notifications.get_token_by_token(token) do
      nil ->
        add_new_token(conn, params)
      token ->
        cond do
          token.user_id != user_id ->
            update_token(conn, token, params)
          true ->
            conn
            |> send_resp(200, Poison.encode!(token))
        end
    end
  end

  defp add_new_token(conn, %{"udid" => udid} = params) do
    case Notifications.get_token_by_udid(udid) do
      nil ->
        add_token_helper(conn, params)
      token ->
        update_token(conn, token, params)
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
