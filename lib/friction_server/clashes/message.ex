defmodule FrictionServer.Clashes.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Poison.Encoder, except: [:__meta__, :poll, :option, :user, :user_id]}

  schema "messages" do
    field :message, :string
    belongs_to :poll, FrictionServer.Clashes.Option, foreign_key: :poll_id
    belongs_to :option, FrictionServer.Clashes.Option, foreign_key: :option_id
    belongs_to :user, FrictionServer.Accounts.User, foreign_key: :user_id

    has_many :claps, FrictionServer.Clashes.Clap
    has_many :dislikes, FrictionServer.Clashes.Dislike

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :poll_id, :option_id, :user_id])
    |> validate_required([:message, :poll_id, :option_id, :user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:option)
    |> assoc_constraint(:poll)
  end

  def map(message) do
    %{id: message.id, message: message.message,
      claps: Enum.sum(Enum.map(message.claps, fn clap -> clap.claps end)),
      dislikes: Enum.sum(Enum.map(message.dislikes, fn dislike -> dislike.dislikes end)),
      poll_id: message.poll_id, option_id: message.option_id, name: message.user.name, image_url: message.user.image_url, inserted_at: message.inserted_at}
  end

  def map(message, user_id) do
    ret =
    map(message)
    |> Map.merge(%{
      added_clap: Enum.find(message.claps, fn clap -> clap.user_id == user_id end),
      added_dislike: Enum.find(message.dislikes, fn dislike -> dislike.user_id == user_id end)
    })
  end

  defimpl Poison.Encoder, for: FrictionServer.Clashes.Message do
    def encode(message, options) do
      user_id = options |> Keyword.get(:user_id)
      Poison.Encoder.Map.encode(FrictionServer.Clashes.Message.map(message, user_id), options)
    end
  end
end
