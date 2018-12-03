defmodule FrictionServer.Repo.Migrations.RemoveVotesCount do
  use Ecto.Migration

  def change do
    create table(:options, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :poll_id, references(:polls, type: :binary_id, on_delete: :nothing)
    end

    alter table(:votes) do
      remove :option_id
      add :option_id, references(:options, type: :binary_id, on_delete: :nothing)
    end

    alter table(:polls) do
      remove :options
    end

    create index(:votes, [:option_id])
    create index(:options, [:poll_id])
  end
end
