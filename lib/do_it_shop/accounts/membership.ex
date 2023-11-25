defmodule DoItShop.Accounts.Membership do
  @moduledoc """
  The Member Schema. A member is the relationship between users and accounts
  and tells which accounts a user have access to
  """
  use DoItShop.Schema
  import Ecto.Changeset

  schema "account_memberships" do
    field :role, Ecto.Enum, values: [:owner, :member], default: :member

    belongs_to :member, DoItShop.Accounts.Member, foreign_key: :user_id
    belongs_to :account, DoItShop.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role])
    |> validate_required([:role])
    |> unique_constraint(:member, name: :account_memberships_account_id_user_id_index)
  end
end
