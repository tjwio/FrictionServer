defmodule FrictionServerWeb.UserControllerTest do
  use FrictionServerWeb.ConnCase

  alias FrictionServer.Accounts

  @create_attrs %{email: "some email", image_url: "some image_url", name: "some name", password: "some password", password_hash: "some password_hash"}
  @update_attrs %{email: "some updated email", image_url: "some updated image_url", name: "some updated name", password: "some updated password", password_hash: "some updated password_hash"}
  @invalid_attrs %{email: nil, image_url: nil, name: nil, password: nil, password_hash: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
