defmodule FrictionServer.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :message, :string
      add :claps, :integer

      add :poll_id, references(:polls, type: :binary_id, on_delete: :nothing)
      add :option_id, references(:options, type: :binary_id, on_delete: :nothing)
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:option_id])
    create index(:messages, [:poll_id])
  end
end
