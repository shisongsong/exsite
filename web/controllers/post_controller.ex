defmodule Exsite.PostController do
  require IEx
  use Exsite.Web, :controller
  alias Exsite.{Post, Comment}
  alias Exsite.Bll.{PostBll, TopicBll}
  plug :authenticate_user when action in [:new, :create]

  def index(conn, _params) do
    posts = Post |> Repo.all
    conn
    |> assign(:posts, posts)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    root_topics = TopicBll.root_topics
    conn
    |> assign(:changeset, changeset)
    |> assign(:root_topics, root_topics)
    |> render("new.html")
  end

  def create(conn, %{"post" => post_params}) do
    post_params =
      post_params
      |> Map.merge(%{"user_id" => get_session(conn, :user_id)})

    case PostBll.create(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "post created")
        |> redirect(to: post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          root_topics: TopicBll.root_topics)
    end
  end

  def show(conn, %{"id" => id}) do
    post = 
      Post
      |> preload([:topic, :user, :comments, comments: [
          :user, :replies, replies: [:user, :reply, reply: :user]]])
      |> Repo.get(id)
    changeset = Comment.changeset(%Comment{})
    render conn, "show.html", post: post, changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    root_topics = TopicBll.root_topics
    post =
      Post
      |> preload([:topic, :user])
      |> Repo.get!(id)

    changeset = Post.changeset(post)
    conn
    |> assign(:post, post)
    |> assign(:changeset, changeset)
    |> assign(:root_topics, root_topics)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = 
      Post
      |> Repo.get(id)

    IEx.pry
    changeset = 
      post
      |> Post.changeset(post_params)
      
    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "post update")
        |> redirect(to: post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "edit.html",
          post: post,
          changeset: changeset,
          root_topics: TopicBll.root_topics)
    end
  end
end
