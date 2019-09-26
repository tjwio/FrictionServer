defmodule FrictionServer.Repo.Migrations.CreateUniqueTokenIndex do
  use Ecto.Migration

  def change do
    create unique_index(:tokens, [:token])
  end
end
