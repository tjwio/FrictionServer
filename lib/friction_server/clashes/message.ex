defmodule FrictionServer.Clashes.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Poison.Encoder, except: [:__meta__, :poll, :option, :user, :user_id]}

  schema "messages" do
    field :message, :string
    field :claps, :integer, default: 0
    belongs_to :poll, FrictionServer.Clashes.Option, foreign_key: :poll_id
    belongs_to :option, FrictionServer.Clashes.Option, foreign_key: :option_id
    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :claps, :poll_id, :option_id, :user_id])
    |> validate_required([:message, :poll_id, :option_id, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:option)
    |> assoc_constraint(:poll)
  end
end
