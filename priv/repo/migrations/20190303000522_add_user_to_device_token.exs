defmodule FrictionServer.Repo.Migrations.AddUserToDeviceToken do
  use Ecto.Migration

  def change do
    alter table(:tokens) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
    end

    create index(:tokens, [:user_id])
  end
end
