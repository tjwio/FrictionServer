# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :friction_server,
  ecto_repos: [FrictionServer.Repo]

# Configures the endpoint
config :friction_server, FrictionServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jmj7UoyueKQriFKyh+MQ7jWe5uLswggOAGm9k97ajPcUVtJKwmoJRlb6Vs0p4T6t",
  render_errors: [view: FrictionServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FrictionServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :friction_server, FrictionServer.Authentication.Guardian,
       issuer: "friction_server",
       ttl: { 30, :days },
       allowed_drift: 2000,
       secret_key: "9oci+UKjjuGCcbpqrTDdSHS+pDWKjO/o3slHuTnPzhvTwRTcLuNR10my4Y3v7A4q"

config :ex_aws,
       access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
       secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
       s3: [
         scheme: "https://",
         host: "s3-elixir.s3.amazonaws.com",
         region: System.get_env("AWS_REGION")
       ]

config :pigeon, :apns,
       apns_default: %{
         cert: """
         Bag Attributes
             friendlyName: Apple Push Services: io.tjw.friction
             localKeyID: 0F CE 7C 40 29 E5 49 2D 87 EE D2 87 3B 91 29 75 F4 1D E3 19
         subject=/UID=io.tjw.friction/CN=Apple Push Services: io.tjw.friction/OU=9JBA7R48SP/O=Tim Wong/C=US
         issuer=/C=US/O=Apple Inc./OU=Apple Worldwide Developer Relations/CN=Apple Worldwide Developer Relations Certification Authority
         -----BEGIN CERTIFICATE-----
         MIIGBDCCBOygAwIBAgIIW1HiQ0efZCgwDQYJKoZIhvcNAQELBQAwgZYxCzAJBgNV
         BAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3Js
         ZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3
         aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
         HhcNMTgxMjAxMDkzOTM4WhcNMTkxMjMxMDkzOTM4WjCBhTEfMB0GCgmSJomT8ixk
         AQEMD2lvLnRqdy5mcmljdGlvbjEtMCsGA1UEAwwkQXBwbGUgUHVzaCBTZXJ2aWNl
         czogaW8udGp3LmZyaWN0aW9uMRMwEQYDVQQLDAo5SkJBN1I0OFNQMREwDwYDVQQK
         DAhUaW0gV29uZzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
         ggEKAoIBAQC9vNHXU1VvFoM9YptES1FNQDCw6hppLLtHUmt8eFTgo3MVwHu1wmTZ
         nbj4nje7vvqrA935JxDGDQYOKVyQnxqBI1edOAwGxAHsXMgVuz3/oFVY3+H4BKzt
         rBgYN1Zw6n2AjnK3Ut41Q+R8xiwzWzluiQLveAqPTHiv+yK+YDC77nYf0g0zNcns
         5D6vd/YGGEyiMkDLl9lHbb1cQyqOnDO59d3pDicFCxiVp5fhfx0R+ZoXYaZ7vC5P
         blmMhh4JFEmx1iXoSJEcfpxmkxxpUcMBr5GT1kcY7jf2aKHvpJWYg51F3LM+0Xq3
         Ov821ycF8m2TI7mbz5mXbkZiNSS31BbvAgMBAAGjggJjMIICXzAMBgNVHRMBAf8E
         AjAAMB8GA1UdIwQYMBaAFIgnFwmpthhgi+zruvZHWcVSVKO3MIIBHAYDVR0gBIIB
         EzCCAQ8wggELBgkqhkiG92NkBQEwgf0wgcMGCCsGAQUFBwICMIG2DIGzUmVsaWFu
         Y2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2Nl
         cHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5k
         IGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRp
         ZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wNQYIKwYBBQUHAgEWKWh0dHA6
         Ly93d3cuYXBwbGUuY29tL2NlcnRpZmljYXRlYXV0aG9yaXR5MBMGA1UdJQQMMAoG
         CCsGAQUFBwMCMDAGA1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9jcmwuYXBwbGUuY29t
         L3d3ZHJjYS5jcmwwHQYDVR0OBBYEFA/OfEAp5Ukth+7ShzuRKXX0HeMZMA4GA1Ud
         DwEB/wQEAwIHgDAQBgoqhkiG92NkBgMBBAIFADAQBgoqhkiG92NkBgMCBAIFADB0
         BgoqhkiG92NkBgMGBGYwZAwPaW8udGp3LmZyaWN0aW9uMAUMA2FwcAwUaW8udGp3
         LmZyaWN0aW9uLnZvaXAwBgwEdm9pcAwcaW8udGp3LmZyaWN0aW9uLmNvbXBsaWNh
         dGlvbjAODAxjb21wbGljYXRpb24wDQYJKoZIhvcNAQELBQADggEBAMfg6p8TABHZ
         fBsOoIy6VRX0w4eudrh5UiR2jaPOiHY/pxnM4+y5f+uZGWbd5WuCsm4IWFYk4gQ3
         9YQ4OGyDWesfEOxMxBYpgbbdPBfglRmBdeecnRrMCH3oJ+jZIT5dJ9gLuY14Tqz7
         b3CR2+hp4xBJMcOy7FOHbRUXH7ocStzdQR38NxyznBmaloHxw7o25IYDJMEJvYS/
         pnxK1kCbV09HnAapx+GEaCBQYitXuZdXgwo3+3+YGiMClWHa9wxgrqiMUAi7BJAX
         bgQe4vIzsAiLavMKO4jvDSSTteXyRaJVqn6pv4fjTVYUwn2p0p/ITIznP+7wFPzy
         UGgdh8yV40E=
         -----END CERTIFICATE-----
         """,
         key: """
         -----BEGIN RSA PRIVATE KEY-----
         MIIEogIBAAKCAQEAvbzR11NVbxaDPWKbREtRTUAwsOoaaSy7R1JrfHhU4KNzFcB7
         tcJk2Z24+J43u776qwPd+ScQxg0GDilckJ8agSNXnTgMBsQB7FzIFbs9/6BVWN/h
         +ASs7awYGDdWcOp9gI5yt1LeNUPkfMYsM1s5bokC73gKj0x4r/sivmAwu+52H9IN
         MzXJ7OQ+r3f2BhhMojJAy5fZR229XEMqjpwzufXd6Q4nBQsYlaeX4X8dEfmaF2Gm
         e7wuT25ZjIYeCRRJsdYl6EiRHH6cZpMcaVHDAa+Rk9ZHGO439mih76SVmIOdRdyz
         PtF6tzr/NtcnBfJtkyO5m8+Zl25GYjUkt9QW7wIDAQABAoIBAGdV5/9a7oPDAhUz
         mBaY4p2tIRepWFsBtrnAZLP0oV17B5nILFgwmFaA9RXKrdX9zG3JfGJO6W7D9xFN
         a5GEZZ4Bjp0cwkgJBnchjQNw5/JJ81GlFV/LxBbpjHHb6aMzwsh6THYVltnxsQZX
         tAkAXQYbbtLXUQD8iBpoL2L55nDjHT85YB1q1iH6D5zoCwLZ8IHWIMSOeVVO9NwG
         M04NPQXPlpG7wWL1/gcB63w9AiU6cBW3JK+Y1lBjIME4FkeE8h2RMbhe4n+jpCnD
         fEPmpn5VO2xFNX8L1ggCpePGzJ/ZSyX2+W2AvY/yyFFpyDc1a5IABJ8GEZzSh08C
         AjItoCkCgYEA6qFgGI8scXy2E7YifWQu1xaXFlcB0e0qrItE7IOffcwAQMo6zKC6
         CaNUdSULxib7ABPan1CrEJUpHSWIyc9wqDZIUMJ3hTaLn/pb2Vpf0l/Pay4/b4PP
         QlEdvAzruGxEaBaSYbN1WSAHCLeBxUNgLgRhf/FIiCWDkG4CHEmNtMMCgYEAzwS6
         KA9vOxkHVTu1ZND0i4BTpZHcjfL1Ju27ZPcNL1Hmk/OyRhFS0qY2g8h154m6Ja2q
         oNffNHR3egnQ0HV9fcLSnNdgUh5DzfyLy06r3TA7nNJjWqHp9LULkUkdoayWksCb
         XMen7zx/+ttTC99DU35Z+p1GhTEixoZyabFQwmUCgYBMpKpfW2WJLNPNXJGnpDIo
         0JhKE+HkUTS/aD77g4N19E2g3G6YqWgb/d545cES2WjkfZfMsu0uXYswmjI0ui5y
         xEibGOsx+L9jYsTeG0dx0RpQSKswIj5xy02LQC0/8R3nYngushCDLJMfpdIePgQN
         BCFVSdwHnTl81HKcCurfQQKBgBHCQA3rtQkGzqA7LQZm/nNxILvVVWw/6VPblPXG
         U7U5e2Q5xZNJLSew5oBLlAG2yOcujLKbkiQ30YAAk48uZQOC0PpvZ23j9sEW5w8b
         wpaI6rQ7QBaoSR+a4FEoSohx+8C/ERTWc8uMDxZ/9hHQpz/kWOes0j3exzLsmagD
         dAAZAoGAWlERUh+bavCiatGcYGHXCgl+d1gKVyfxrrOfuqD4uwsibjf5IMOwbq6o
         I76Vv2TYyDML29woCfjZ/xaI09enye8LMC3wloBVgB8rl2Vopys3R7Wgra6AAKRo
         d/vdGKGqzVFGQ93JUfSkZAUBI9I4pU9/cL/RxXxW0QDMsJTKEaw=
         -----END RSA PRIVATE KEY-----
         """,
         mode: :prod
       }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"