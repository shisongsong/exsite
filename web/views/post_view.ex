defmodule Exsite.PostView do
  use Exsite.Web, :view

  alias Exsite.User

  def current_user do
    @current_user
  end

  def current_user? do
    case @current_user do
      %User{} -> true
      nil -> false
    end
  end
end
