defmodule FrictionServer.Notifications do
  @moduledoc """
  The Notifications context.
  """

  require Logger

  import Ecto.Query, warn: false
  alias FrictionServer.Repo

  alias FrictionServer.Notifications.Token

  @app_bundle_id "io.tjw.friction"

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens do
    Repo.all(Token)
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id), do: Repo.get!(Token, id)

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(%{field: value})
      {:ok, %Token{}}

      iex> create_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a token.

  ## Examples

      iex> update_token(token, %{field: new_value})
      {:ok, %Token{}}

      iex> update_token(token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking token changes.

  ## Examples

      iex> change_token(token)
      %Ecto.Changeset{source: %Token{}}

  """
  def change_token(%Token{} = token) do
    Token.changeset(token, %{})
  end

  def send_notification(notification) do
    list_tokens()
    |> Enum.each(fn token -> send_notification(notification, token) end)
  end

  defp send_notification(notification, token) do
    packet = Pigeon.APNS.Notification.new(notification, token, @app_bundle_id)
        |> Pigeon.APNS.Notification.put_badge(1)
    Pigeon.APNS.push(packet, on_response: &on_notification_response/1)
  end

  defp on_notification_response(response) do
    case response do
      :success ->
        Logger.debug "Push successful!"
      :bad_device_token ->
        Logger.error "Bad device token!"
      _error ->
        Logger.error "Some other error happened."
    end
  end
end