defmodule DoItShop.Tenant.Org do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:org_id, :id, autogenerate: true}
  schema "orgs" do
    field :company_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:company_name])
    |> validate_required([:company_name])
  end
end
