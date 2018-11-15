defmodule FrictionServer.Authentication.Guardian do
  @moduledoc false

  use Guardian, otp_app: :friction_server

  alias FrictionServer.{Repo, Accounts.User}

  def subject_for_token(user = %User{}, _claims), do: {:ok, "User:#{user.id}"}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => "User:" <> uid_str}), do: {:ok, Repo.get(User, uid_str)}
  def resource_from_claims(_), do: {:error, "Unknown resource type"}

end
