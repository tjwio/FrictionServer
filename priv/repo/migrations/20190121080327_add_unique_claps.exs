defmodule FrictionServer.Repo.Migrations.AddUniqueClaps do
  use Ecto.Migration

  def change do
    create unique_index(:claps, [:user_id, :message_id], name: :user_message_index)
  end
end
