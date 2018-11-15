defmodule FrictionServer.Pipelines.Auth do
  @moduledoc false

  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
      otp_app: :friction_server,
      module: FrictionServer.Authentication.Guardian,
      error_handler: FrictionServer.Authentication.ErrorHandler

  plug(Guardian.Plug.VerifySession, claims: @claims)
  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)

end
