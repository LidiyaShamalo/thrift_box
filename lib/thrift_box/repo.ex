defmodule ThriftBox.Repo do
  use Ecto.Repo,
    otp_app: :thrift_box,
    adapter: Ecto.Adapters.Postgres
end
