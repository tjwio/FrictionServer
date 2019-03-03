defmodule FrictionServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__, :password, :password_hash, :votes, :tokens]}

  schema "users" do
    field :email, :string
    field :image_url, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :votes, FrictionServer.Clashes.Vote, foreign_key: :user_id
    has_many :tokens, FrictionServer.Notifications.Token, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :image_url])
    |> validate_required([:name, :email])
    |> validate_email
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :image_url, :password])
    |> validate_required([:name, :email, :password])
    |> validate_changeset
  end

  def image_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image_url])
  end

  defp validate_changeset(struct) do
    struct
    |> validate_email
    |> validate_password
  end

  defp validate_email(struct) do
    struct
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp validate_password(struct) do
    struct
    |> validate_length(:password, min: 6)
      #    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/, [message: "Must include at least one lowercase letter, one uppercase letter, and one digit"])
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
