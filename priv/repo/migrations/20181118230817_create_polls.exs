defmodule FrictionServer.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :options, {:array, :map}, default: []

      timestamps()
    end

  end
end
