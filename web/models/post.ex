defmodule Exsite.Post do
  use Exsite.Web, :model
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :content, :string
    field :content_format, :string, default: "html"
    field :last_commented_at, Ecto.DateTime
    field :last_comment_user_id, :integer
    field :state, :integer, default: 0
    field :commentes_count, :integer, default: 0
    field :favorates_count, :integer, default: 0
    field :suggested_at, Ecto.DateTime
    field :deleted_at, Ecto.DateTime
    belongs_to :user, Exsite.User
    belongs_to :topic, Exsite.Topic
    has_many :comments, Exsite.Comment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields [
    :title,
    :content,
    :user_id,
    :topic_id]

  @cast_fields @required_fields ++ [
    :last_commented_at,
    :last_comment_user_id,
    :commentes_count,
    :favorates_count,
    :suggested_at,
    :suggested_at,
    :deleted_at]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
  end
end
