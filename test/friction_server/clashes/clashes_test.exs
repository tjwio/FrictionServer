defmodule FrictionServer.ClashesTest do
  use FrictionServer.DataCase

  alias FrictionServer.Clashes

  describe "polls" do
    alias FrictionServer.Clashes.Poll

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def poll_fixture(attrs \\ %{}) do
      {:ok, poll} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Clashes.create_poll()

      poll
    end

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert Clashes.list_polls() == [poll]
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert Clashes.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      assert {:ok, %Poll{} = poll} = Clashes.create_poll(@valid_attrs)
      assert poll.name == "some name"
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clashes.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      assert {:ok, poll} = Clashes.update_poll(poll, @update_attrs)
      assert %Poll{} = poll
      assert poll.name == "some updated name"
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Clashes.update_poll(poll, @invalid_attrs)
      assert poll == Clashes.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = Clashes.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> Clashes.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = Clashes.change_poll(poll)
    end
  end
end
