defmodule Exsite.Repo.Migrations.CreateReply do
  use Ecto.Migration

  def change do
    create table(:replies) do
      add :content, :text
      add :content_format, :string
      add :state, :integer
      add :floor_number, :integer
      add :modified_at, :utc_datetime
      add :deleted_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :comment_id, references(:comments, on_delete: :nothing)
      add :reply_id, references(:replies, on_delete: :nothing)

      timestamps()
    end
    create index(:replies, [:user_id])
    create index(:replies, [:comment_id])
    create index(:replies, [:reply_id])

  end
end
