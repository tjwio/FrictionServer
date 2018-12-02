defmodule FrictionServerWeb.UploadController do
  use FrictionServerWeb, :controller

  alias FrictionServer.{Repo, Accounts.User}

  def upload(conn, %{"file" => upload_params}) do
    user = FrictionServer.Authentication.Guardian.Plug.current_resource(conn)
    resp = upload_to_s3(upload_params)

    changeset = User.image_changeset(user, %{image_url: resp.s3_url})

    case Repo.update(changeset) do
      {:ok, new_user} ->
        conn
        |> send_resp(200, Poison.encode!(new_user))
      {:error,  %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(changeset.errors))
    end
  end

  defp upload_to_s3(upload_params) do
    file_uuid = UUID.uuid4(:hex)
    image_filename = upload_params.filename
    unique_filename = "#{file_uuid}-#{image_filename}"
    {:ok, image_binary} = File.read(upload_params.path)
    bucket_name = System.get_env("BUCKET_NAME")
    region = System.get_env("AWS_REGION")

    ExAws.S3.put_object(bucket_name, unique_filename, image_binary)
    |> ExAws.request!

    s3_url = "https://s3-#{region}.amazonaws.com/#{bucket_name}/#{bucket_name}/#{unique_filename}"
    %{
      s3_url: s3_url
    }
  end

end
