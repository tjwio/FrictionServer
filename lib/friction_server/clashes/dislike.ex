defmodule FrictionServer.Clashes.Dislike do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Poison.Encoder, except: [:__meta__, :user_id, :user, :message]}

  schema "dislikes" do
    field :dislikes, :integer, default: 0

    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id
    belongs_to :message, FrictionServer.Clashes.Message, foreign_key: :message_id

    timestamps()
  end

  @doc false
  def changeset(dislike, attrs) do
    dislike
    |> cast(attrs, [:dislikes, :user_id, :message_id])
    |> validate_required([:dislikes, :user_id, :message_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:message)
    |> unique_constraint(:user, name: :dislike_user_message_index)
  end

end
