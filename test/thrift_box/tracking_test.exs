defmodule ThriftBox.TrackingTest do

  use ThriftBox.DataCase

  alias ThriftBox.Tracking

  describe "budgets" do
    alias ThriftBox.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = ThriftBox.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "some name",
        description: "some description",
        start_date: ~D[2026-01-01],
        end_date: ~D[2026-01-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
      assert budget.start_date == ~D[2026-01-01]
      assert budget.end_date == ~D[2026-01-31]
      assert budget.creator_id == user.id
    end
  end

end
