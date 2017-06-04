defmodule Exsite.Bll.TopicBll do
  alias Exsite.Topic
  alias Exsite.Dal.TopicDal

  def get_all() do
    TopicDal.get_all
  end

  def get_by_id(id) do
    TopicDal.get_by_id(id)
  end

  def root_topics do
    TopicDal.get_root_topics
  end

  def default_root_topic do
    TopicDal.get_default_root_topic
  end

  def get_children(topic) do
    TopicDal.get_children(topic.id)
  end

  def create(topic_params) do
    changeset = Topic.changeset(%Topic{}, topic_params)
    TopicDal.create(changeset)
  end

  def get_default_topic do
    topics = TopicDal.get_root_topics
  end
end
