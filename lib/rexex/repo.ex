defmodule Rexex.Repo do
  use Ecto.Repo,
    otp_app: :rexex,
    adapter: Ecto.Adapters.Postgres
end
