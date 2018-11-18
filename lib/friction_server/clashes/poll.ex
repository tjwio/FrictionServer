defmodule FrictionServer.Clashes.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "polls" do
    field :name, :string
    embeds_many :options, FrictionServer.Clashes.Option

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
