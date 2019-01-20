defmodule FrictionServer.Repo.Migrations.AddMessageDislikes do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :dislikes, :integer
    end
  end
end
