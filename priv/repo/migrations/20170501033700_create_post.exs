defmodule Exsite.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :content_format, :string
      add :last_commented_at, :utc_datetime
      add :last_comment_user_id, :integer
      add :state, :integer
      add :commentes_count, :integer
      add :favorates_count, :integer
      add :suggested_at, :utc_datetime
      add :deleted_at, :utc_datetime
      add :topic_id, references(:topics, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:user_id])
    create index(:posts, [:topic_id])
  end
end
