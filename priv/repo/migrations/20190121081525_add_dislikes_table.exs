defmodule FrictionServer.Repo.Migrations.AddDislikesTable do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :dislikes
    end

    create table(:dislikes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :dislikes, :integer

      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :message_id, references(:messages, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:dislikes, [:user_id])
    create index(:dislikes, [:message_id])
    create unique_index(:dislikes, [:user_id, :message_id], name: :dislike_user_message_index)
  end
end
