defmodule Exsite.Auth do
  use Phoenix.Controller #使用controller的方法
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0] 
  alias Exsite.Router.Helpers
  require IEx

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Exsite.User, user_id)
    assign(conn, :current_user, user)
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  # 使用用户名和密码登录
  def login_by_given_input_and_pass(conn, given_input, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Exsite.User, nickname: given_input) || repo.get_by(Exsite.User, email: given_input)

    cond do
      user && checkpw(given_pass, user.encrypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  # 退出登录
  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
