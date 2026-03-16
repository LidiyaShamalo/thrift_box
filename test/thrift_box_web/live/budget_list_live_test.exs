defmodule ThriftBoxWeb.BudgetListLiveTest do
  #alias ElixirLS.LanguageServer.Plugins.Phoenix
  #создает соединение, делая доступными функции регистрации и входа в систему
  use ThriftBoxWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import ThriftBox.TrackingFixtures

  # доступность user для тестов
  setup do
    user = ThriftBox.AccountsFixtures.user_fixture()

    %{user: user}
  end

  describe "Index view" do
    test "shows budget when one exists", %{conn: conn, user: user} do
      budget = budget_fixture(%{creator_id: user.id})

      conn = log_in_user(conn, user)
      {:ok, lv, html} = live(conn, ~p"/budgets")

      open_browser(lv)

      assert html =~ budget.name
      assert html =~ budget.description
    end
  end
end
