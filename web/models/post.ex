defmodule Exsite.Post do
  use Exsite.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string
    field :content_format, :string
    field :last_commented_at, Ecto.DateTime
    field :last_comment_user_id, :integer
    field :state, :integer
    field :commentes_count, :integer
    field :favorates_count, :integer
    field :suggested_at, Ecto.DateTime
    field :deleted_at, Ecto.DateTime
    belongs_to :user, Exsite.User
    belongs_to :topic, Exsite.Topic

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :content_format, :last_commented_at, :last_comment_user_id, :topic_id, :state, :commentes_count, :favorates_count, :suggested_at, :deleted_at])
    |> validate_required([:title, :content, :content_format, :last_commented_at, :last_comment_user_id, :topic_id, :state, :commentes_count, :favorates_count, :suggested_at, :deleted_at])
  end
end
