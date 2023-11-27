defmodule DoItShop.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    # ORGANIZATIONS
    create table(:orgs, primary_key: false) do
      add :org_id, :bigserial, primary_key: true
      add :company_name, :string

      timestamps(type: :utc_datetime)
    end

    # ROLES
    create table(:roles) do
      add :org_id,
          references(:orgs, column: :org_id, on_delete: :delete_all),
          null: false

      add :role, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:role, :org_id])
    create index(:roles, [:org_id])

    # USERS
    create table(:users) do
      add :email, :citext, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false

      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime

      add :role_id,
          references(:roles, on_delete: :delete_all),
          null: false

      add :org_id,
          references(:orgs, column: :org_id, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    execute """
      ALTER TABLE users
        ADD COLUMN searchable tsvector
        GENERATED ALWAYS AS (
          setweight(to_tsvector('english', coalesce(first_name, '')), 'A') ||
          setweight(to_tsvector('english', coalesce(last_name, '')), 'B') ||
          setweight(to_tsvector('english', coalesce(email, '')), 'C')
        ) STORED;
    """

    execute """
      CREATE INDEX users_searchable_idx ON users USING gin(searchable);
    """

    create unique_index(:users, [:email])
    create index(:users, [:org_id])

    # USER TOKENS
    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
