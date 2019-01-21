defmodule FrictionServer.Repo.Migrations.AddClapsTable do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :claps
    end

    create table(:claps, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :claps, :integer

      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :message_id, references(:messages, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:claps, [:user_id])
    create index(:claps, [:message_id])
  end
end
