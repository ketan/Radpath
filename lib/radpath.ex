defmodule Radpath do
  alias :file, as: F
  alias :zip, as: Z
  use Application.Behaviour
  use Radpath.Dirs
  use Radpath.Files
  use Radpath.Tempfs

  def start(_type, _args) do
    Radpath.Supervisor.start_link
  end

  defmacro __using__([]) do
    quote do
      use Radpath.Dirs
      use Radpath.Files
      use Radpath.Tempfs
    end
  end

  @doc """
   To create symlink: Radpath.symlink(source, destination). Source must exist.
   """
  def symlink(source, destination) do
    if File.exists?(source) do
      F.make_symlink(source, destination)
    end
  end
  
  @doc """
  
  To create a zip archive: Radpath.zip(archive_name, [dir1, file1, dir2])

  """
  def zip(archive_name, dirs) when is_list(dirs) do
    Z.zip(archive_name, dirs(dirs))
  end

  defp do_mkdir(path) do
    if !File.exists?(path) do
      File.rm_rf(path)
      case File.mkdir(path) do
        :ok -> path
        error -> error
      end
    end
  end

  defp make_into_path(path_str) do
    Path.absname(path_str) <> "/"
  end
end