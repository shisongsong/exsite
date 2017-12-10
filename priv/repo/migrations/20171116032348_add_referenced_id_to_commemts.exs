defmodule Exsite.Repo.Migrations.AddReferencedIdToCommemts do
  use Ecto.Migration

  def change do
    alter table("comments") do
      add :referenced_id, references(:comments, on_delete: :nothing)
    end
  end
end
