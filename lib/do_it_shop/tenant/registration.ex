defmodule DoItShop.Tenant.Registration do
  defstruct company_name: nil, email: nil, password: nil

  # validate we have org and user info required to register new user
  def changeset(%DoItShop.Tenant.Registration{} = registration, attrs \\ %{}) do
    registration
    |> DoItShop.Tenant.Org.changeset(attrs)
    |> DoItShop.Accounts.User.registration_changeset(attrs)
  end

  def tenant_registration_changeset(%DoItShop.Tenant.Registration{} = registration, attrs \\ %{}) do
    registration
    |> DoItShop.Tenant.Org.changeset(attrs)
    |> DoItShop.Accounts.User.registration_changeset(attrs)
  end
end
