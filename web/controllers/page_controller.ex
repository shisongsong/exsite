defmodule Exsite.PageController do
  use Exsite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
