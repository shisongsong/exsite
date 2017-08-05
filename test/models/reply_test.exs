defmodule Exsite.ReplyTest do
  use Exsite.ModelCase

  alias Exsite.Reply

  @valid_attrs %{content: "some content", content_format: "some content", deleted_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, floor_number: 42, modified_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, state: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Reply.changeset(%Reply{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Reply.changeset(%Reply{}, @invalid_attrs)
    refute changeset.valid?
  end
end
