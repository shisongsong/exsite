defmodule Exsite.Reply do
  use Exsite.Web, :model

  schema "replies" do
    field :content, :string
    field :content_format, :string, default: "html"
    field :state, :integer, default: 0
    field :floor_number, :integer
    field :modified_at, Timex.Ecto.DateTime
    field :deleted_at, Timex.Ecto.DateTime

    belongs_to :user, Exsite.User
    belongs_to :comment, Exsite.Comment
    belongs_to :reply, Exsite.Reply, foreign_key: :reply_id
    has_many :replies, Exsite.Reply, foreign_key: :reply_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  @required_fields [
    :content,
    :user_id,
    :comment_id]

  @cast_fields @required_fields ++ [
    :content_format,
    :floor_number,
    :deleted_at,
    :modified_at]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
  end
end
