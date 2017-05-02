defmodule Exsite.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :name, :string
      add :position, :integer
      add :parent_topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end
    create index(:topics, [:parent_topic_id])
    create index(:topics, [:position])
  end
end
