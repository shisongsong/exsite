defmodule Exsite.Repo.Migrations.AddDeletedAtToComments do
  use Ecto.Migration

  def change do
    alter table("comments") do
      add :deleted_at, :utc_datetime
    end
  end
end
