defmodule Exsite.TopicTest do
  use Exsite.ModelCase

  alias Exsite.Topic

  @valid_attrs %{name: "some content", parent_topic_id: 42, position: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Topic.changeset(%Topic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Topic.changeset(%Topic{}, @invalid_attrs)
    refute changeset.valid?
  end
end
