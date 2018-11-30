defmodule FrictionServer.Clashes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__]}

  schema "votes" do
    field :poll_id, :string
    field :option_id, :string
    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:poll_id, :option_id, :user_id])
    |> validate_required([:poll_id, :option_id, :user_id])
    |> assoc_constraint(:user)
  end

end
