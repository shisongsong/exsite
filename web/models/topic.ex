defmodule Exsite.Topic do
  use Exsite.Web, :model

  schema "topics" do
    field :name, :string
    field :position, :integer
    field :deleted_at, Timex.Ecto.DateTime
    has_many :children, Exsite.Topic, foreign_key: :parent_topic_id
    belongs_to :parent, Exsite.Topic, foreign_key: :parent_topic_id
    has_many :posts, Exsite.Post

    timestamps()
  end

  @required_fields [
    :name,
    :position]

  @cast_fields @required_fields ++ [
    :parent_topic_id,
    :name,
    :deleted_at,
    :position]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:parent_topic_id)
  end
end
