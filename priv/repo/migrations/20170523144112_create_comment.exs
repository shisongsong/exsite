defmodule Exsite.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :user_id, references(:users)
      add :post_id, references(:posts)
      add :content, :text
      add :content_format, :string
      add :state, :integer
      add :floor_number, :integer

      timestamps()
    end

  end
end
