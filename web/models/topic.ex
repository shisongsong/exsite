defmodule Exsite.Topic do
  use Exsite.Web, :model

  schema "topics" do
    field :name, :string
    field :position, :integer
    belongs_to :topic, Exsite.Topic, foreign_key: :parent_topic_id
    has_many :posts, Exsite.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:parent_topic_id, :name, :position])
    |> validate_required([:parent_topic_id, :name, :position])
  end
end
