defmodule Exsite.ReplyView do
  use Exsite.Web, :view

  def render("show_reply.json", %{reply: reply}) do
    %{reply: reply_json(reply)}
  end

  def reply_json(reply) do
    %{
      content: reply.content,
      inserted_at: time_formatter(reply.inserted_at),
      updated_at: time_formatter(reply.updated_at)
    }
  end
end
