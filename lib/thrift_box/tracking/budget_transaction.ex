defmodule ThriftBox.Tracking.BudgetTransaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "budget_transactions" do
    field :type, Ecto.Enum, values: [:funding, :spending]
    field :description, :string
    field :effective_date, :date
    field :amount, :decimal
    belongs_to :budget, ThriftBox.Tracking.Budget

    #field :budget_id, :binary_id
    #field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget_transaction, attrs) do #, user_scope) do
    budget_transaction
    |> cast(attrs, [:effective_date, :type, :amount, :description, :budget_id])
    |> validate_required([:effective_date, :type, :amount, :description, :budget_id])
    #|> put_change(:user_id, user_scope.user.id)
    |> validate_number(:amount, greater_than_or_equl_to: 0)
  end
end
