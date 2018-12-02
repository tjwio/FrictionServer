defmodule FrictionServer.NotificationsTest do
  use FrictionServer.DataCase

  alias FrictionServer.Notifications

  describe "tokens" do
    alias FrictionServer.Notifications.Token

    @valid_attrs %{token: "some token"}
    @update_attrs %{token: "some updated token"}
    @invalid_attrs %{token: nil}

    def token_fixture(attrs \\ %{}) do
      {:ok, token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifications.create_token()

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Notifications.list_tokens() == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Notifications.get_token!(token.id) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Notifications.create_token(@valid_attrs)
      assert token.token == "some token"
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifications.create_token(@invalid_attrs)
    end

    test "update_token/2 with valid data updates the token" do
      token = token_fixture()
      assert {:ok, token} = Notifications.update_token(token, @update_attrs)
      assert %Token{} = token
      assert token.token == "some updated token"
    end

    test "update_token/2 with invalid data returns error changeset" do
      token = token_fixture()
      assert {:error, %Ecto.Changeset{}} = Notifications.update_token(token, @invalid_attrs)
      assert token == Notifications.get_token!(token.id)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Notifications.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Notifications.get_token!(token.id) end
    end

    test "change_token/1 returns a token changeset" do
      token = token_fixture()
      assert %Ecto.Changeset{} = Notifications.change_token(token)
    end
  end
end
