defmodule FrictionServer.Repo.Migrations.AddVoteTable do
  use Ecto.Migration

  def change do
    create table(:votes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :poll_id, :string
      add :option_id, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:votes, [:user_id])
  end
end
