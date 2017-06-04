defmodule Exsite.TopicController do
  use Exsite.Web, :controller
  alias Exsite.Bll.{TopicBll, PostBll}
  alias Exsite.{Topic, Post}

  def index(conn, _params) do
    topics = TopicBll.get_all
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic_params}) do
    case TopicBll.create(topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "topic created")
        |> redirect(to: topic_path(conn, :index))

      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => id, "page" => page}) do
    topic =
      Topic
      |> preload([:children, :parent])
      |> Repo.get!(id)
    topics_ids = Enum.map(topic.children, fn(t) -> t.id end) ++ [id]
    page =
      Post
      |> where([p], p.topic_id in ^topics_ids)
      |> order_by(desc: :inserted_at)
      |> preload([:topic, :user])
      |> Repo.paginate(page: page)

    conn
    |> assign(:topic, topic)
    |> assign(:page, page)
    |> render("show.html")
  end 

  def show(conn, %{"id" => id}) do
    show(conn, %{"id" => id, "page" => 1})
  end

  def edit(conn, %{"id" => id}) do
    topic = TopicBll.get_by_id(id)
    changeset = Topic.changeset(topic)
    render conn, "edit.html", topic: topic, changeset: changeset
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = TopicBll.get_by_id(id) 
    changeset = Topic.changeset(topic, topic_params)

    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: topic_path(conn, :show, topic))
      {:error, changeset} ->
        render "edit.html", topic: topic, changeset: changeset
    end
  end
end
