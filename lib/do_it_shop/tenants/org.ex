defmodule DoItShop.Tenants.Org do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:org_id, :id, autogenerate: true}
  schema "orgs" do
    field :company_name, :string

    has_many :users, DoItShop.Accounts.User, foreign_key: :org_id
    has_many :roles, DoItShop.Tenants.Role, foreign_key: :org_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:company_name])
    |> validate_required([:company_name])
  end
end
