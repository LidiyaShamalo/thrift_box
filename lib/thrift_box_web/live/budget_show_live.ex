defmodule ThriftBoxWeb.BudgetShowLive do
  use ThriftBoxWeb, :live_view

  alias ThriftBox.Tracking

  def mount(%{"budget_id" => id}, _session, socket) when is_uuid(id) do
    budget =
      # Tracking.get_budget(id)
      # |> ThriftBox.Repo.preload(:creator)
      Tracking.get_budget(id,
        user: socket.assigns.current_scope.user,
        preload: :creator
      )

    if budget do
      {:ok, assign(socket, budget: budget)}
    else
      socket =
        socket
        |> put_flash(:error, "Budget not found")
        |> redirect(to: ~p"/budgets")

      {:ok, socket}
    end
  end

  def mount(_invalid_id, _session, socket) do
    socket =
      socket
      |> put_flash(:error, "Budget not found")
      |> redirect(to: ~p"/budgets")

      {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    {@budget.name} by {@budget.creator.name}
    """
  end
end
