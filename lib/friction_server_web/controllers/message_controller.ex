defmodule FrictionServerWeb.MessageController do
  @moduledoc false

  use FrictionServerWeb, :controller

  def add_claps(conn, %{"id" => message_id, "claps" => claps}) do
    message = Clashes.get_message!(message_id)

    case Clashes.update_message(message, %{claps: claps}) do
      {:ok, message} ->
        conn
        |> send_resp(200, Poison.encode!(message))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> send_resp(400, Poison.encode!(message: "Failed to update message"))
    end
  end

end
