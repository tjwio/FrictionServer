defmodule FrictionServer.Notifications.Token do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tokens" do
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
