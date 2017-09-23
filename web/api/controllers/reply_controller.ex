defmodule Exsite.ReplyController do
  require IEx

  use Exsite.Web, :controller

  alias Exsite.Router.Helpers
  alias Exsite.{Reply, Comment, Post}
  plug :authenticate_user

  # reply_id
  #   the id of replied reply 
  def create(conn, %{"comment_id" => comment_id,
    "reply_id" => reply_id, "reply" => reply}) do
      reply = 
        reply
        |> Map.merge(%{"reply_id" => reply_id})
      create(conn, %{"comment_id" => comment_id, "reply" => reply})
  end

  def create(conn, %{"comment_id" => comment_id, "reply" => reply}) do
    user_id =
      conn
      |> get_session(:user_id)

    comment =
      Comment
      |> preload([:post])
      |> Repo.get!(comment_id)

    post = comment.post

    IEx.pry
    reply =
      reply
      |> Map.merge(%{"user_id" => user_id, "comment_id" => comment_id,
          "content" => reply["content"]})

    changeset = Reply.changeset(%Reply{}, reply)
    case Repo.insert(changeset) do
      {:ok, reply} ->
        {:ok, post} =
          post
          |> Post.changeset(%{last_commented_at: reply.inserted_at})
          |> Repo.update

        conn |> json(%{post: post, reply: reply, comment: comment})
      {:error, changeset} ->
        conn |> json(%{changeset: changeset})
    end
  end
end
