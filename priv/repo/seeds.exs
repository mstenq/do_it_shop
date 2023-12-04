# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DoItShop.Repo.insert!(%DoItShop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias DoItShop.Tenants.Org
alias DoItShop.Accounts
alias DoItShop.Tasks

defmodule Seed do
  def seed_tenant(user) do
    create_employees(user)
    create_task_statuses()
    create_tasks(user)
  end

  def random_user_id(user) do
    Enum.random(Range.new(user.id, user.id + 3))
  end

  def create_employees(user) do
    # Create employees for each tenant
    employees =
      [
        %{
          "first_name" => "Andy",
          "last_name" => "Admin",
          "email" => "andy.admin",
          "password" => "password"
        },
        %{
          "first_name" => "Ursula",
          "last_name" => "User",
          "email" => "ursala.user",
          "password" => "password"
        },
        %{
          "first_name" => "Gary",
          "last_name" => "Guest",
          "email" => "gary.guest",
          "password" => "password"
        }
      ]
      |> Enum.with_index()
      |> Enum.each(fn {employee, index} ->
        employee = Map.put(employee, "role_id", user.role_id + index + 1)

        employee =
          Map.put(
            employee,
            "email",
            employee["email"] <> "+" <> to_string(user.id) <> "@email.com"
          )

        Accounts.add_user_to_org(employee)
      end)
  end

  def create_task_statuses do
    [
      %{
        "title" => "Backlog",
        "position" => 1
      },
      %{
        "title" => "In Progress",
        "position" => 2
      },
      %{
        "title" => "Done",
        "position" => 3
      }
    ]
    |> Enum.each(fn status -> Tasks.create_status(status) end)
  end

  def create_task(user, i, status_ids) do
    today = Date.utc_today()

    %{
      "due_date" => Date.add(today, Enum.random(1..10)),
      "notes" => "This is a note #{i}",
      "priority" => Enum.random([:high, :medium, :low]),
      "qty" => Enum.random(1..10),
      "status_id" => Enum.random(status_ids),
      "title" => "This is a task #{i}",
      "assigned_user_id" => Seed.random_user_id(user)
    }
  end

  def create_tasks(user) do
    status_ids =
      Tasks.list_task_status()
      |> Enum.map(fn status -> status.id end)

    Enum.each(1..100, fn i -> Tasks.create_task(Seed.create_task(user, i, status_ids)) end)
  end
end

# Register orgs
{:ok, main_user} =
  Accounts.register_user(%{
    "company_name" => "Do It Shop",
    "first_name" => "Mason",
    "last_name" => "Stenquist",
    "email" => "mason.sten@gmail.com",
    "password" => "password"
  })

Seed.seed_tenant(main_user)

{:ok, secondary_user} =
  Accounts.register_user(%{
    "company_name" => "Custom Covers",
    "first_name" => "Justin",
    "last_name" => "Jones",
    "email" => "justin.jones@gmail.com",
    "password" => "password"
  })

Seed.seed_tenant(secondary_user)
