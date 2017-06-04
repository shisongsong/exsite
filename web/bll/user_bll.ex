defmodule Exsite.Bll.UserBll do
  alias Exsite.User
  alias Exsite.Dal.UserDal

  def get_all do
    UserDal.get_all
  end

  def get_by_id(id) do
    UserDal.get_by_id(id)
  end

  def get_by_nickname(nickname) do
    UserDal.get_by_nickname(nickname)
  end

  def create(user_params) do
    changeset = User.registration_changeset(%User{}, user_params)
    UserDal.create(changeset)
  end

  def update(id, user_params) do
    UserDal.update(id, user_params)
  end
end
