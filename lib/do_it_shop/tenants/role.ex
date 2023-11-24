defmodule DoItShop.Tenants.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias DoItShop.Tenants.Org

  schema "roles" do
    field :description, :string
    field :role, :string

    belongs_to :org, Org, references: :org_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:org_id, :role, :description])
    |> validate_required([:org_id, :role, :description])
  end
end
