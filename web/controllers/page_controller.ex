defmodule Exsite.PageController do
  use Exsite.Web, :controller
  alias Exsite.{Post, Topic}
  alias Exsite.Bll.PostBll
  alias Exsite.Bll.TopicBll

  def index(conn, %{"root_topic" => root_topic, "page" => page}) do
    root_topics = TopicBll.root_topics
    root_topic = TopicBll.get_by_id(root_topic)
    posts = PostBll.get_by_topics([root_topic])
    topics_ids = Enum.map(root_topic.children, fn(t) -> t.id end) ++ [root_topic.id]
    page =
      Post
      |> where([p], p.topic_id in ^topics_ids)
      |> order_by(desc: :inserted_at)
      |> preload([:topic, :user])
      |> Repo.paginate(page: page)

    conn
    |> assign(:root_topics, root_topics)
    |> assign(:root_topic, root_topic || nil)
    |> assign(:children_topics, root_topic.children)
    |> assign(:page, page)
    |> render("index.html")
  end

  def index(conn, %{"page" => page}) do
    root_topic = TopicBll.default_root_topic
    index(conn, %{"root_topic" => root_topic.id, "page" => page})
  end

  def index(conn, %{"root_topic" => root_topic}) do
    root_topic = TopicBll.get_by_id(root_topic)
    index(conn, %{"root_topic" => root_topic.id, "page" => 1})
  end

  def index(conn, _params) do
    index(conn, %{"page" => 1})
  end
end
