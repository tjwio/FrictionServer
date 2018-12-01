defmodule FrictionServer.Clashes.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__]}

  @min_options 1

  schema "polls" do
    field :name, :string
    embeds_many :options, FrictionServer.Clashes.Option

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:name])
    |> cast_embed(:options)
    |> validate_required([:name, :options])
    |> validate_length(:options, min: @min_options)
  end
end
