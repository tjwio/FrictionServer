defmodule FrictionServer.Clashes.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__, :messages]}

  @min_options 1

  schema "polls" do
    field :name, :string
    has_many :options, FrictionServer.Clashes.Option
    has_many :messages, FrictionServer.Clashes.Message

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:name])
    |> cast_assoc(:options)
    |> validate_required([:name, :options])
    |> validate_length(:options, min: @min_options)
  end
end
