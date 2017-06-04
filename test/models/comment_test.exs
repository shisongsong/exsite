defmodule Exsite.CommentTest do
  use Exsite.ModelCase

  alias Exsite.Comment

  @valid_attrs %{content: "some content", content_format: "some content", floor_number: 42, post_id: 42, state: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
