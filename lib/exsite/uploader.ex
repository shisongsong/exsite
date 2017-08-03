defmodule Exsite.Uploader do
  def upload(path, filename \\ "", uploader \\ Exsite.QiniuUploader) do
    uploader.upload(path, filename)
  end
end

defmodule Exsite.QiniuUploader do
  require IEx
  def upload(path, key) do
    # Get put_policy from Qiniu.config[:bucket].
    #   :bucket is a repo in your Qiniu Cloud.
    put_policy = Qiniu.PutPolicy.build(Qiniu.config[:bucket])
    res = Qiniu.Uploader.upload(put_policy, path, key: key)
    if res.status_code >= 200 && res.status_code < 300 do
      url = Path.join(Qiniu.config[:domain], res.body["key"])
      {:ok, url}
    else
      {:error, "Fail to upload!"}
    end
  end
end
