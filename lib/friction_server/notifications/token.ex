defmodule FrictionServer.Notifications.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :user, :user_id]}
  @foreign_key_type :binary_id

  schema "tokens" do
    field :token, :string
    field :udid, :string
    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :udid, :user_id])
    |> validate_required([:token, :udid])
    |> assoc_constraint(:user)
    |> unique_constraint(:token)
    |> unique_constraint(:udid)
  end
end
