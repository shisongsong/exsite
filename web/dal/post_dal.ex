defmodule Exsite.Dal.PostDal do
  use Exsite.Web, :dal
  alias Exsite.Post
  require IEx

  def get_all do
    Repo.all(Post)
  end

  def get_all(deleted) do
    Post
    |> where([p], p.deleted_at)
    |> Repo.all()
  end

  def get_by_id(id) do
    Post
    |> preload([:topic, :user, :comments, comments: :user])
    |> Repo.get!(id)
  end

  def get_by_ids(ids) when is_list(ids) do
    Post
    |> where([p], p.id in ^ids)
    |> Repo.all()
  end

  def get_by_title(title) do
    Post
    |> where([p], ^title in p.title)
    |> Repo.all()
  end

  def get_by_topics(ids) do
    Post
    |> preload([:topic, :user])
    |> where([p], p.topic_id in ^ids)
    |> Repo.all()
  end

  def get_by_user(user_id) do
    Post
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
  end

  def create(changeset) do
    Repo.insert(changeset)
  end

  def update(id, post_params) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)
    Repo.update(changeset)
  end

  def delete(id) do
    post = Repo.get!(Post, id)
    Repo.delete!(post)
  end
end
