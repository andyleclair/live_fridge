defmodule LiveFridge.Repo do
  use Ecto.Repo,
    otp_app: :live_fridge,
    adapter: Ecto.Adapters.Postgres
end
