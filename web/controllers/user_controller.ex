defmodule Exsite.UserController do
  use Exsite.Web, :controller
  alias Exsite.{User, Post, Comment, Reply}
  alias Exsite.Bll.UserBll
  plug :authenticate_user when action in [:index]
  require IEx

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users 
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  # 注册后自动登录
  def create(conn, %{"user" => user_params}) do
   ### changeset = User.registration_changeset(%User{}, user_params)
   ### case Repo.insert(changeset) do
   ###   {:ok, user} ->
   ###     conn
   ###     |> Exsite.Auth.login(user)
   ###     |> put_flash(:info, "#{user.nickname} created")
   ###     |> redirect(to: user_path(conn, :index))
   ###   {:error, changeset} ->
   ###     render(conn, "new.html", changeset: changeset)
   ### end

    case UserBll.create(user_params) do
      {:ok, user} ->
        conn
        |> Exsite.Auth.login(user)
        |> put_flash(:info, "#{user.nickname} created")
        |> redirect(to: user_path(conn, :show))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => id,
                   "tab_key" => tab_key,
                   "page" => page}) do
    data =
      case tab_key do
        "posts" ->
          Post |> preload([:user, :topic])
        "comments" ->
          Comment
        "replies"->
          Reply
        _ ->
          User
      end
      |> Repo.paginate([page: page, page_size: 50])
    user = Repo.get!(User, id)

    conn
    |> assign(:current_tab_key, tab_key)
    |> assign(:data, data)
    |> render(:show, user: user)
  end

  def show(conn, %{"user_id" => id, "tab_key" => tab_key}), do:
    show(conn, %{"user_id" => id, "tab_key" => tab_key, "page" => 1})
  def show(conn, %{"id" => id, "page" => page}), do:
    show(conn, %{"user_id" => id, "tab_key" => "posts", "page" => page})
  def show(conn, %{"id" => id}), do:
    show(conn, %{"id" => id, "page" => 1})
end
