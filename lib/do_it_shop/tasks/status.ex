defmodule DoItShop.Tasks.Status do
  use Ecto.Schema
  import Ecto.Changeset
  alias DoItShop.Tasks.Task

  schema "task_status" do
    field :position, :integer
    field :title, :string

    has_many :tasks, Task, foreign_key: :status_id
    field :org_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:title, :position])
    |> DoItShop.Repo.set_org()
    |> validate_required([:title, :position])
  end
end
