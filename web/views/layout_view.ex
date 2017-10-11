defmodule Exsite.LayoutView do
  use Exsite.Web, :view
  
  def current_user(conn) do
    conn |> Map.get(:current_user)
  end

  def current_user?(conn) do
    case current_user(conn) do
      user -> true 
      nil -> false
    end
  end
end
