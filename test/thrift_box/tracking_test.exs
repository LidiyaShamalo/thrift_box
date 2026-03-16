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

  test "create_budget/2 require name" do
    user = ThriftBox.AccountsFixtures.user_fixture()

    attr_without_name = %{
      description: "some descroption",
      start_date: ~D[2026-01-01],
      end_date: ~D[2026-01-31],
      creator_id: user.id
    }

    assert {:error, %Ecto.Changeset{} = changeset} =
      Tracking.create_budget(attr_without_name)

    assert changeset.valid? == false
    assert Keyword.keys(changeset.errors) == [:name]
    assert %{name: ["can't be blank"]} = errors_on(changeset)

  end

  test "create_budget/2 require valid dates" do
    user = ThriftBox.AccountsFixtures.user_fixture()

    attrs_end_before_start = %{
      name: "some name",
      description: "some descroption",
      start_date: ~D[2026-01-31],
      end_date: ~D[2026-01-01],
      creator_id: user.id
    }

    assert {:error, %Ecto.Changeset{} = changeset} =
      Tracking.create_budget(attrs_end_before_start)

    assert changeset.valid? == false
    #dbg(changeset) #проверить в чем ошибка
    assert %{end_date: ["must end after start date"]} = errors_on(changeset) # errors_on - вспомогательная функция, которая помогает выводить ошибки
  end

end
