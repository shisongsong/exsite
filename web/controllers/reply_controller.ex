defmodule Exsite.ReplyController do
  use Exsite.Web, :controller

  alias Exsite.Router.Helpers
  alias Exsite.{Reply, Comment, Post}
  plug :authenticate_user

  def create(conn, %{"comment_id" => comment_id,
    "reply_id" => reply_id, "reply" => reply}) do
    user_id =
      conn
      |> get_session(:user_id)

    comment =
      Comment
      |> preload([:post])
      |> Repo.get!(comment_id)

    post =
      comment.post
      |> Repo.preload([:topic, :user])

    reply =
      %{user_id: user_id,
        comment_id: comment_id,
        reply_id: reply_id,
        content: reply["content"]}

    changeset = Reply.changeset(%Reply{}, reply)
    case Repo.insert(changeset) do
      {:ok, reply} ->
        {:ok, post} =
          post
          |> Post.changeset(%{last_commented_at: reply.inserted_at})
          |> Repo.update
        post =
          post
          |> Repo.preload([
              :comments,
              comments: [
                :user,
                :replies,
                replies: [:reply, reply: :user]]
             ])
        redirect conn, to: Helpers.post_path(conn, :show, post)
      {:error, changeset} ->
        render conn, Exsite.PostView, :show, post: post, changeset: changeset
    end
  end
end
