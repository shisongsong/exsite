defmodule Exsite.UserController do
  use Exsite.Web, :controller
  alias Exsite.User
  alias Exsite.Bll.UserBll

  plug :authenticate_user when action in [:index, :show]

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
        |> redirect(to: user_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end
end
