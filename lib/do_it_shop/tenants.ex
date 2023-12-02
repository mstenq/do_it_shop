defmodule DoItShop.Tenants do
  @moduledoc """
  The Tenant context.
  """

  import Ecto.Query, warn: false
  alias DoItShop.Repo

  alias DoItShop.Tenants.Org

  @doc """
  Returns the list of orgs.
  
  ## Examples
  
      iex> list_orgs()
      [%Org{}, ...]
  
  """
  def list_orgs do
    Repo.all(Org)
  end

  @doc """
  Gets a single org.
  
  Raises `Ecto.NoResultsError` if the Org does not exist.
  
  ## Examples
  
      iex> get_org!(123)
      %Org{}
  
      iex> get_org!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_org!(id), do: Repo.get!(Org, id)

  @doc """
  Creates a org.
  
  ## Examples
  
      iex> create_org(%{field: value})
      {:ok, %Org{}}
  
      iex> create_org(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_org(attrs \\ %{}) do
    case %Org{}
         |> Org.changeset(attrs)
         |> Repo.insert() do
      {:ok, org} ->
        # DoItShop.Repo.put_org_id(org.org_id)
        # Create default roles for the Org
        case create_default_roles(org.org_id) do
          {:ok, created_roles} ->
            owner_role = Enum.find(created_roles, fn role -> role.role == "owner" end)
            {:ok, org, owner_role}

          {:error, _} ->
            {:error, %Ecto.Changeset{}}
        end

      {:error, changeset} ->
        changeset
    end
  end

  @doc """
  Updates a org.
  
  ## Examples
  
      iex> update_org(org, %{field: new_value})
      {:ok, %Org{}}
  
      iex> update_org(org, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_org(%Org{} = org, attrs) do
    org
    |> Org.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a org.
  
  ## Examples
  
      iex> delete_org(org)
      {:ok, %Org{}}
  
      iex> delete_org(org)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_org(%Org{} = org) do
    Repo.delete(org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking org changes.
  
  ## Examples
  
      iex> change_org(org)
      %Ecto.Changeset{data: %Org{}}
  
  """
  def change_org(%Org{} = org, attrs \\ %{}) do
    Org.changeset(org, attrs)
  end

  alias DoItShop.Tenants.Role

  @doc """
  Returns the list of roles.
  
  ## Examples
  
      iex> list_roles()
      [%Role{}, ...]
  
  """
  def list_roles do
    Role
    |> where([r], r.role != "owner")
    |> Repo.all()
  end

  @doc """
  Gets a single role.
  
  Raises `Ecto.NoResultsError` if the Role does not exist.
  
  ## Examples
  
      iex> get_role!(123)
      %Role{}
  
      iex> get_role!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.
  
  ## Examples
  
      iex> create_role(%{field: value})
      {:ok, %Role{}}
  
      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  def create_default_roles(org_id) do
    roles = [
      %{role: "owner", description: "Owner"},
      %{role: "admin", description: "Admin"},
      %{role: "user", description: "User"},
      %{role: "guest", description: "Guest"}
    ]

    created_roles =
      Enum.map(roles, fn role ->
        {:ok, role} = create_role(Map.put(role, :org_id, org_id))
        role
      end)

    {:ok, created_roles}
  end

  @doc """
  Updates a role.
  
  ## Examples
  
      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}
  
      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.
  
  ## Examples
  
      iex> delete_role(role)
      {:ok, %Role{}}
  
      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.
  
  ## Examples
  
      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}
  
  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end
end
