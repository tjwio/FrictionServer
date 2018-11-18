defmodule FrictionServer.Clashes.Option do
  use Ecto.Schema
  @moduledoc false

  embedded_schema do
    field :name, :string
    field :votes, :integer, default: 0
  end

end
