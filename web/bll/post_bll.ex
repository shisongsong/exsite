defmodule Exsite.Bll.PostBll do
  alias Exsite.Post
  alias Exsite.Dal.PostDal
  require IEx

  def get_all do
    PostDal.get_all
  end

  def get_by_id(id) do
    PostDal.get_by_id(id)
  end

  def get_by_title(title) do
    PostDal.get_by_title(title)
  end

  def get_by_topics(topics) do
    ids = get_ids_from_list(topics)
    PostDal.get_by_topics(ids)
  end

  def get_by_user(user_id) do
    PostDal.get_by_user(user_id)
  end

  def create(post_params) do
    changeset = Post.changeset(%Post{}, post_params)
    PostDal.create(changeset)
  end

  def update(id, post_params) do
    post = PostDal.get_by_id(id)
    changeset = Post.changeset(post, post_params)
    PostDal.update(changeset)
  end

  def delete(id) do
    PostDal.delete(id)
  end

  defp get_ids_from_list(list) do
    Enum.map(list, fn(e) ->
      if Ecto.assoc_loaded?(e.children) do
        [e.id, get_ids_from_list(e.children)]
      else
        e.id
      end
    end) |> List.flatten()
  end
end
