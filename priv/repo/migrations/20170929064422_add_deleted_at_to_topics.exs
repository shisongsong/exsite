defmodule Exsite.Repo.Migrations.AddDeletedAtToTopics do
  use Ecto.Migration

  def change do
    alter table("topics") do
      add :deleted_at, :utc_datetime
    end
  end
end
