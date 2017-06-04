defmodule Exsite.SessionController do
  use Exsite.Web, :controller
  require IEx

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"given_input" => given_input, "password" => password}}) do
    case Exsite.Auth.login_by_given_input_and_pass(conn, given_input, password, repo: Repo) do
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
    |> send_resp(200, "")
  end
end
