defmodule FrictionServer.Clashes.Option do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Poison.Encoder, except: [:__meta__, :poll, :votes]}

  schema "options" do
    field :name, :string
    field :vote_count, :integer, default: 0, virtual: true
    belongs_to :poll, FrictionServer.Clashes.Poll
    has_many :votes, FrictionServer.Clashes.Vote, foreign_key: :option_id

  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:name])
    |> assoc_constraint(:poll)
    |> validate_required([:name])
  end
end
