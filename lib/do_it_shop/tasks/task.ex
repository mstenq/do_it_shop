defmodule DoItShop.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias DoItShop.Tasks.Status
  alias DoItShop.Users.User

  schema "tasks" do
    field :due_date, :date
    field :notes, :string
    field :priority, Ecto.Enum, values: [:high, :medium, :low]
    field :qty, :integer
    field :title, :string

    belongs_to :status, Status, foreign_key: :status_id
    belongs_to :created_user, User, foreign_key: :created_user_id
    belongs_to :assigned_user, User, foreign_key: :assigned_user_id
    field :org_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :title,
      :due_date,
      :priority,
      :status_id,
      :notes,
      :qty,
      :assigned_user_id
    ])
    |> DoItShop.Repo.set_default_fields()
    |> validate_required([:title, :due_date, :priority, :status_id, :notes, :qty])
  end
end
