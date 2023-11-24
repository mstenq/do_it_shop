defmodule DoItShop.TenantFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DoItShop.Tenant` context.
  """

  @doc """
  Generate a org.
  """
  def org_fixture(attrs \\ %{}) do
    {:ok, org} =
      attrs
      |> Enum.into(%{
        company_name: "some company_name"
      })
      |> DoItShop.Tenant.create_org()

    org
  end
end
