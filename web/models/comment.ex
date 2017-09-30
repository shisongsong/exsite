defmodule Exsite.Comment do
  use Exsite.Web, :model

  schema "comments" do
    field :content, :string
    field :content_format, :string, default: "html"
    field :state, :integer, default: 0
    field :floor_number, :integer
    field :deleted_at, Timex.Ecto.TimestampWithTimezone
    belongs_to :user, Exsite.User
    belongs_to :post, Exsite.Post
    has_many :replies, Exsite.Reply

    timestamps()
  end

  @required_fields [
    :user_id,
    :post_id,
    :content,
    :content_format,
    :floor_number]

  @cast_fields @required_fields ++ [
    :user_id,
    :post_id,
    :content,
    :content_format,
    :deleted_at,
    :state,
    :floor_number]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
  end
end
