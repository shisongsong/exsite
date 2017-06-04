defmodule Exsite.Dal.UserDal do
  use Exsite.Web, :dal
  alias Exsite.{User}

  def get_all do
    Repo.all(User)
  end

  def get_by_id(id) do
    Repo.get(User, id)
  end

  def get_by_nickname(nickname) do
    User
    |> where([u], like(u.nickname, ^"%#{nickname}%"))
    |> Repo.all()
  end

  def create(changeset) do
    Repo.insert(changeset)
  end

  def update(id, user_params) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)
    Repo.update(changeset)
  end
end
