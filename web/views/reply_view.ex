defmodule Exsite.ReplyView do
  use Exsite.Web, :view

  def render("index.json", %{replies: replies}) do
    %{data: render_many(replies, Exsite.ReplyView, "reply.json")}
  end

  def render("show.json", %{reply: reply}) do
    %{data: render_one(reply, Exsite.ReplyView, "reply.json")}
  end

  def render("reply.json", %{reply: reply}) do
    # reply为空时
    replied =
      unless is_nil(reply.reply_id) do
        %{
          id: reply.reply_id,
          user: %{
            id: reply.reply.user_id,
            nickname: reply.reply.user.nickname
          }
        }
      else
        nil
      end

    %{
      id: reply.id,
      content: reply.content,
      user: %{
        id: reply.user_id,
        nickname: reply.user.nickname
      },
      comment: %{
        id: reply.comment_id
      },
      reply: replied,
      inserted_at: reply.inserted_at,
      updated_at: reply.updated_at
    }
  end
end
