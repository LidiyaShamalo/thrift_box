defmodule ThriftBox.Repo.Migrations.CreateBudgetTransactions do
  use Ecto.Migration

  def change do
    create table(:budget_transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :effective_date, :date
      add :type, :string
      add :amount, :decimal
      add :description, :text
      add :budget_id, references(:budgets, on_delete: :delete_all, type: :binary_id)
      #add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    #create index(:budget_transactions, [:user_id])

    create index(:budget_transactions, [:budget_id])
  end
end
