defmodule FrictionServer.Repo.Migrations.AddTimestampsToOptions do
  use Ecto.Migration

  def change do
    alter table(:options) do
      timestamps()
    end
  end
end
