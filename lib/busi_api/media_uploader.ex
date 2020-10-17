defmodule BusiApi.MediaUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def __storage, do: Arc.Storage.Local

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    valid?(file)
  end

  def storage_dir(_, {_file, user}) do
    "uploads/avatars/#{user.id}"
  end

  # To retain the original filename, but prefix the version and user id:
  def filename(version, {file, scope}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))
    "#{scope.id}_#{version}_#{file_name}"
  end

  # To make the destination file the same as the version:
  def filename(version, _), do: version

  def transform(:thumb, {file, _scope}) do
    if valid?(file) do
      {:convert, "-strip -thumbnail 100x100^ -gravity center -extent 100x100 -format png", :png}
    else
      :noaction
    end
  end

  defp valid?(file) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end
end
