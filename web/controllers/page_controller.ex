defmodule Exsite.PageController do
  use Exsite.Web, :controller
  alias Exsite.{Post, Topic}

  def index(conn, _params) do
    
    render conn, "index.html"
  end
end
