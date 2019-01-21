defmodule FrictionServer.Clashes.Clap do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Poison.Encoder, except: [:__meta__, :user_id, :user, :message]}

  schema "claps" do
    field :claps, :integer, default: 0

    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id
    belongs_to :message, FrictionServer.Clashes.Message, foreign_key: :message_id

    timestamps()
  end

  @doc false
  def changeset(clap, attrs) do
    clap
    |> cast(attrs, [:claps, :user_id, :message_id])
    |> validate_required([:claps, :user_id, :message_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:message)
  end

end
