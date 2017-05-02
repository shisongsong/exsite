defmodule Exsite.SessionController do
  use Exsite.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"nickname" => nickname, "password" => password}}) do
    case Exsite.Auth.login_by_nickname_and_pass(conn, nickname, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid nickname/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Exsite.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
