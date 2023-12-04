defmodule DoItShop.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    # TASK STATUS
    create table(:task_status) do
      add :title, :string
      add :position, :integer, null: false

      add :org_id,
          references(:orgs, column: :org_id, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create index(:task_status, [:org_id])

    # TASKS
    create table(:tasks) do
      add :title, :string
      add :due_date, :date
      add :priority, :string
      add :status_id, references(:task_status, on_delete: :nothing)
      add :notes, :text
      add :qty, :integer
      add :created_user_id, references(:users, on_delete: :nothing)
      add :assigned_user_id, references(:users, on_delete: :nothing)

      add :org_id,
          references(:orgs, column: :org_id, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    execute """
      ALTER TABLE tasks
        ADD COLUMN searchable tsvector
        GENERATED ALWAYS AS (
          setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
          setweight(to_tsvector('english', coalesce(notes, '')), 'B')
        ) STORED;
    """

    execute """
      CREATE INDEX tasks_searchable_idx ON tasks USING gin(searchable);
    """

    create index(:tasks, [:status_id])

    create index(:tasks, [:created_user_id])
    create index(:tasks, [:assigned_user_id])
    create index(:tasks, [:org_id])
  end
end
