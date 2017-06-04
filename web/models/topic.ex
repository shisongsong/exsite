defmodule Exsite.Topic do
  use Exsite.Web, :model

  schema "topics" do
    field :name, :string
    field :position, :integer
    has_many :children, Exsite.Topic, foreign_key: :parent_topic_id
    belongs_to :parent, Exsite.Topic, foreign_key: :parent_topic_id
    has_many :posts, Exsite.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:parent_topic_id, :name, :position])
    |> validate_required([:name, :position])
    |> foreign_key_constraint(:parent_topic_id)
  end
end
