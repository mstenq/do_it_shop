defmodule DoItShop.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `DoItShop.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        due_date: ~D[2023-11-27],
        notes: "some notes",
        priority: :high,
        qty: 42,
        status: "some status",
        title: "some title"
      })
      |> DoItShop.Tasks.create_task()

    task
  end

  @doc """
  Generate a status.
  """
  def status_fixture(attrs \\ %{}) do
    {:ok, status} =
      attrs
      |> Enum.into(%{
        position: 42,
        title: "some title"
      })
      |> DoItShop.Tasks.create_status()

    status
  end
end
