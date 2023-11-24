defmodule DoItShop.TenantsTest do
  use DoItShop.DataCase

  alias DoItShop.Tenants

  describe "orgs" do
    alias DoItShop.Tenants.Org

    import DoItShop.TenantsFixtures

    @invalid_attrs %{company_name: nil}

    test "list_orgs/0 returns all orgs" do
      org = org_fixture()
      assert Tenants.list_orgs() == [org]
    end

    test "get_org!/1 returns the org with given id" do
      org = org_fixture()
      assert Tenants.get_org!(org.id) == org
    end

    test "create_org/1 with valid data creates a org" do
      valid_attrs = %{company_name: "some company_name"}

      assert {:ok, %Org{} = org} = Tenants.create_org(valid_attrs)
      assert org.company_name == "some company_name"
    end

    test "create_org/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_org(@invalid_attrs)
    end

    test "update_org/2 with valid data updates the org" do
      org = org_fixture()
      update_attrs = %{company_name: "some updated company_name"}

      assert {:ok, %Org{} = org} = Tenants.update_org(org, update_attrs)
      assert org.company_name == "some updated company_name"
    end

    test "update_org/2 with invalid data returns error changeset" do
      org = org_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_org(org, @invalid_attrs)
      assert org == Tenants.get_org!(org.id)
    end

    test "delete_org/1 deletes the org" do
      org = org_fixture()
      assert {:ok, %Org{}} = Tenants.delete_org(org)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_org!(org.id) end
    end

    test "change_org/1 returns a org changeset" do
      org = org_fixture()
      assert %Ecto.Changeset{} = Tenants.change_org(org)
    end
  end
end
