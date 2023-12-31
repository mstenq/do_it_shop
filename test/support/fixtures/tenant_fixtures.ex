defmodule DoItShop.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DoItShop.Tenants` context.
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
      |> DoItShop.Tenants.create_org()

    org
  end
end
