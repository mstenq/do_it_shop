defmodule DoItShop.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :due_date, :date
    field :notes, :string
    field :priority, Ecto.Enum, values: [:high, :medium, :low]
    field :qty, :integer
    field :status, :string
    field :title, :string
    field :created_user_id, :id
    field :assigned_user_id, :id
    field :org_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :due_date, :priority, :status, :notes, :qty])
    |> set_org()
    |> validate_required([:title, :due_date, :priority, :status, :notes, :qty])
  end

  defp set_org(changeset) do
    put_change(changeset, :org_id, DoItShop.Store.get_org_id())
  end
end
