defmodule DoItShop.TenantsTest do
  use DoItShop.DataCase

  alias DoItShop.Tenants

  describe "roles" do
    alias DoItShop.Tenants.Role

    import DoItShop.TenantsFixtures

    @invalid_attrs %{description: nil, org_id: nil, role: nil}

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Tenants.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Tenants.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      valid_attrs = %{description: "some description", org_id: 42, role: "some role"}

      assert {:ok, %Role{} = role} = Tenants.create_role(valid_attrs)
      assert role.description == "some description"
      assert role.org_id == 42
      assert role.role == "some role"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenants.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      update_attrs = %{description: "some updated description", org_id: 43, role: "some updated role"}

      assert {:ok, %Role{} = role} = Tenants.update_role(role, update_attrs)
      assert role.description == "some updated description"
      assert role.org_id == 43
      assert role.role == "some updated role"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenants.update_role(role, @invalid_attrs)
      assert role == Tenants.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Tenants.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Tenants.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Tenants.change_role(role)
    end
  end
end
