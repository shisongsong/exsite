defmodule Exsite.Comment do
  use Exsite.Web, :model

  schema "comments" do
    field :content, :string
    field :content_format, :string, default: "html"
    field :state, :integer, default: 0
    field :floor_number, :integer
    belongs_to :user, Exsite.User
    belongs_to :post, Exsite.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id, :content, :content_format, :state, :floor_number])
    |> validate_required([:user_id, :post_id, :content, :content_format, :floor_number])
  end
end