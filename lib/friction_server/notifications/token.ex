defmodule FrictionServer.Notifications.Token do
  use Ecto.Schema
  import Ecto.Changeset


  schema "tokens" do
    field :token, :string
    field :udid, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :udid])
    |> validate_required([:token, :udid])
  end
end
