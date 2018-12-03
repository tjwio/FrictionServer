defmodule FrictionServer.Repo.Migrations.CreateUniqueVoteIndex do
  use Ecto.Migration

  def change do
    create unique_index(:votes, [:user_id, :poll_id], name: :user_poll_index)
  end
end
