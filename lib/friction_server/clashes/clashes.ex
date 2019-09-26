defmodule FrictionServer.Clashes do
  @moduledoc """
  The Clashes context.
  """

  import Ecto.Query, warn: false
  alias FrictionServer.Repo

  alias FrictionServer.Clashes.{Clap, Dislike, Message, Poll, Vote}

  @doc """
  Returns the list of polls.

  ## Examples

      iex> list_polls()
      [%Poll{}, ...]

  """
  def list_polls do
    Repo.all(Poll)
    |> Repo.preload([:options, options: :votes])
  end

  @doc """
  Gets a single poll.

  Raises `Ecto.NoResultsError` if the Poll does not exist.

  ## Examples

      iex> get_poll!(123)
      %Poll{}

      iex> get_poll!(456)
      ** (Ecto.NoResultsError)

  """
  def get_poll!(id), do: Repo.get!(Poll, id) |> Repo.preload([:options, options: :votes])

  def get_vote!(id), do: Repo.get!(Vote, id)

  def get_clap!(id), do: Repo.get!(Clap, id)

  def get_dislike!(id), do: Repo.get!(Dislike, id)

  def get_latest_poll! do
    Repo.one!(from x in Poll, order_by: [desc: x.inserted_at], limit: 1)
    |> Repo.preload([:options, options: :votes])
  end

  def get_votes(user) do
    user = Repo.preload user, :votes

    user.votes
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def get_messages(poll) do
    poll = Repo.preload poll, [:messages, messages: [:user, :claps, :dislikes]]

    poll.messages
  end

  def get_stats(poll) do
    poll = FrictionServer.Repo.preload(poll, [:options, options: :messages])

    Enum.map(poll.options, fn option ->
      %{option_id: option.id, claps: Enum.sum(Enum.map(option.messages, fn message -> message.claps end)), messages: Enum.count(option.messages)}
    end)
  end



  @doc """
  Creates a poll.

  ## Examples

      iex> create_poll(%{field: value})
      {:ok, %Poll{}}

      iex> create_poll(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  def create_vote(user, attrs) do
    attrs = attrs |> Map.put("user_id", user.id)
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_clap(user, attrs) do
    attrs = attrs |> Map.put(:user_id, user.id)
    %Clap{}
    |> Clap.changeset(attrs)
    |> Repo.insert()
  end

  def create_dislike(user, attrs) do
    attrs = attrs |> Map.put(:user_id, user.id)
    %Dislike{}
    |> Dislike.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a poll.

  ## Examples

      iex> update_poll(poll, %{field: new_value})
      {:ok, %Poll{}}

      iex> update_poll(poll, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_poll(%Poll{} = poll, attrs) do
    poll
    |> Poll.changeset(attrs)
    |> Repo.update()
  end

  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def update_clap(%Clap{} = clap, attrs) do
    clap
    |> Clap.changeset(attrs)
    |> Repo.update()
  end

  def update_dislike(%Dislike{} = dislike, attrs) do
    dislike
    |> Dislike.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Poll.

  ## Examples

      iex> delete_poll(poll)
      {:ok, %Poll{}}

      iex> delete_poll(poll)
      {:error, %Ecto.Changeset{}}

  """
  def delete_poll(%Poll{} = poll) do
    Repo.delete(poll)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking poll changes.

  ## Examples

      iex> change_poll(poll)
      %Ecto.Changeset{source: %Poll{}}

  """
  def change_poll(%Poll{} = poll) do
    Poll.changeset(poll, %{})
  end
end
