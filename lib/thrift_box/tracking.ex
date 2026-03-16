defmodule ThriftBox.Tracking do
  import Ecto.Query, warn: false

  alias ThriftBox.Repo
  alias ThriftBox.Tracking.Budget

  def create_budget(attrs \\ %{}) do
    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end
end
