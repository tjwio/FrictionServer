defmodule FrictionServer.Clashes.Option do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc false

  embedded_schema do
    field :name, :string
    field :votes, :integer, default: 0
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:name, :votes])
    |> validate_required([:name])
  end
end
