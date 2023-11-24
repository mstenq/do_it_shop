defmodule DoItShop.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DoItShop.Tenants` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        description: "some description",
        org_id: 42,
        role: "some role"
      })
      |> DoItShop.Tenants.create_role()

    role
  end
end
