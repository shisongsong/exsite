defmodule Exsite.Post do
  use Exsite.Web, :model
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :content, :string
    field :content_format, :string, default: "markdown"
    field :last_commented_at, Timex.Ecto.DateTime
    field :last_comment_user_id, :integer
    field :state, :integer, default: 0
    field :commentes_count, :integer, default: 0
    field :favorates_count, :integer, default: 0
    field :suggested_at, Timex.Ecto.DateTime
    field :deleted_at, Timex.Ecto.DateTime
    belongs_to :user, Exsite.User
    belongs_to :topic, Exsite.Topic
    has_many :comments, Exsite.Comment
    has_many :replies, through: [:comments, :replies]

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
    :state,
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
