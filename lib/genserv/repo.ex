defmodule Genserv.Repo do
  use Ecto.Repo,
    otp_app: :genserv,
    adapter: Ecto.Adapters.Postgres
end
