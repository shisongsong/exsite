defmodule Exsite.ImageController do
  require IEx
  use Exsite.Web, :controller
  @prefix "image"

  def create(conn, %{"upload" => upload}) do
   filename = generate_filename(upload["file"])
    case Exsite.Uploader.upload(upload["file"].path, filename) do
      {:ok, url} ->
        conn |> send_resp(200, url)
      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(%{error: reason})
    end
  end

  defp generate_filename(file) do
    md5 = Base.encode16(:erlang.md5(file.path), case: :lower)
    ext = file.content_type |> String.split("/") |> List.last
    [@prefix, "/", md5, ".", ext] |> Enum.join
  end
end
