defmodule FrictionServer.Repo.Migrations.AddUdidToken do
  use Ecto.Migration

  def change do
    alter table(:tokens) do
      add :udid, :string
    end

    create unique_index(:tokens, [:udid])
  end
end
