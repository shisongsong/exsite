defmodule Exsite.CommentController do
  use Exsite.Web, :controller

  alias Exsite.Router.Helpers
  alias Exsite.{Comment, Post}
  plug :authenticate_user

  def create(conn, %{"post_id" => post_id, "comment" => comment}) do
    user_id = get_session(conn, :user_id)
    post =
      Post
      |> preload([:user, :topic, :comments])
      |> Repo.get!(post_id)

    comment = %{post_id: post_id,
                user_id: user_id,
                content: comment["content"],
                floor_number: max_floor_number(post)
              }
    changeset = Comment.changeset(%Comment{}, comment)
    case Repo.insert(changeset) do
      {:ok, comment} ->
        # TODO add replies
        comment = comment |> Repo.preload([:post, :user])
        {:ok, post} =
          post
          |> Post.changeset(%{last_commented_at: comment.inserted_at,
                              commentes_count: length(post.comments) + 1})
          |> Repo.update
        post = post |> Repo.preload(:comments)
        redirect conn, to: Helpers.post_path(conn, :show, post)
      {:error, changeset} ->
        render conn, Exsite.PostView, :show, post: post, changeset: changeset
    end
  end

  defp max_floor_number(post) do
    query = from(c in Comment, where: c.post_id == ^post.id, select: max(c.floor_number))
    if floor_number = Repo.one!(query) do
      floor_number + 1
    else
      1
    end
  end
end
