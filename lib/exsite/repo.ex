defmodule Exsite.Repo do
  use Ecto.Repo, otp_app: :exsite
  use Scrivener, page_size: 20
end
