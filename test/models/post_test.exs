defmodule Exsite.PostTest do
  use Exsite.ModelCase

  alias Exsite.Post

  @valid_attrs %{commentes_count: 42, content: "some content", content_format: "some content", deleted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, favorates_count: 42, last_comment_user_id: 42, last_commented_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, state: 42, suggested_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content", topic_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
