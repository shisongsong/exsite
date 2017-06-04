defmodule Exsite.Dal.TopicDal do
  use Exsite.Web, :dal
  alias Exsite.Topic

  def get_all do
    Repo.all(Topic)
  end

  def get_by_id(id) do
    Topic
    |> preload([:children, :parent])
    |> Repo.get(id)
  end

  def get_root_topics do
    Topic
    |> where([t], is_nil(t.parent_topic_id))
    |> order_by(asc: :position)
    |> preload(:children)
    |> Repo.all()
  end

  def get_default_root_topic do
    Topic
    |> where([t], is_nil(t.parent_topic_id))
    |> first(asc: :position)
    |> Repo.one()
  end

  def get_by_id(id) do
    Repo.get(Topic, id)
  end

  def get_children(id) do
    Topic
    |> preload(:children)
    |> Repo.get(id)
  end

  def create(changeset) do
    Repo.insert(changeset)
  end
end
