defmodule Exsite.User do
  use Exsite.Web, :model

  schema "users" do
    field :nickname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string
    has_many :posts, Exsite.Post
    has_many :comments, Exsite.Comment
    has_many :replies, Exsite.Reply

    timestamps()
  end

  @derive {Poison.Encoder, only: [:id, :nickname, :email]}

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:nickname, :email], [])
    |> validate_length(:nickname, min: 4, max: 20)
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> unique_constraint(:email)
    |> unique_constraint(:nickname)
    |> validate_length(:password, min: 6, max: 100)
    |> generate_encrypted_password()
  end

  # 对密码进行加密处理
  def generate_encrypted_password current_changeset do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(
          current_changeset,
          :encrypted_password,
          Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        current_changeset
    end
  end
end
