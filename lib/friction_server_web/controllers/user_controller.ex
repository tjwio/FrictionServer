defmodule FrictionServerWeb.UserController do
  use FrictionServerWeb, :controller

  alias FrictionServer.Accounts
  alias FrictionServer.Accounts.User

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = FrictionServer.Guardian.encode_and_sign(user, %{}, permissions: %{user: []})
        conn
        |> send_resp(200, Poison.encode!(%{token: jwt, user: user}))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_authenticated_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = FricationServer.Guardian.encode_and_sign(user, %{}, permissions: %{user: []})
        conn
        |> send_resp(200, Poison.encode!(%{token: jwt, user: user}))
      {:error, reason} ->
        conn
        |> send_resp(401, Poison.encode!(%{message: "Invalid email or password"}))
    end
  end

  def show(conn, _params) do
    user = FricationServer.Guardian.Plug.current_resource(conn)

    conn
    |> send_resp(200, Poison.encode!(user))
  end

  def update(conn, params) do
    user = FrictionServer.Guardian.Plug.current_resource(conn)

    case Accounts.update_user(user, params) do
      {:ok, user} ->
        conn
        |> send_resp(200, Poison.encode!(user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> send_resp(200, Poison.encode!(%{message: "Success"}))
  end
end
