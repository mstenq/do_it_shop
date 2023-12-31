defmodule DoItShop.TasksTest do
  use DoItShop.DataCase

  alias DoItShop.Tasks

  describe "tasks" do
    alias DoItShop.Tasks.Task

    import DoItShop.TasksFixtures

    @invalid_attrs %{due_date: nil, notes: nil, priority: nil, qty: nil, status: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{due_date: ~D[2023-11-27], notes: "some notes", priority: :high, qty: 42, status: "some status", title: "some title"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.due_date == ~D[2023-11-27]
      assert task.notes == "some notes"
      assert task.priority == :high
      assert task.qty == 42
      assert task.status == "some status"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{due_date: ~D[2023-11-28], notes: "some updated notes", priority: :medium, qty: 43, status: "some updated status", title: "some updated title"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.due_date == ~D[2023-11-28]
      assert task.notes == "some updated notes"
      assert task.priority == :medium
      assert task.qty == 43
      assert task.status == "some updated status"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "task_status" do
    alias DoItShop.Tasks.Status

    import DoItShop.TasksFixtures

    @invalid_attrs %{position: nil, title: nil}

    test "list_task_status/0 returns all task_status" do
      status = status_fixture()
      assert Tasks.list_task_status() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert Tasks.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{position: 42, title: "some title"}

      assert {:ok, %Status{} = status} = Tasks.create_status(valid_attrs)
      assert status.position == 42
      assert status.title == "some title"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      update_attrs = %{position: 43, title: "some updated title"}

      assert {:ok, %Status{} = status} = Tasks.update_status(status, update_attrs)
      assert status.position == 43
      assert status.title == "some updated title"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_status(status, @invalid_attrs)
      assert status == Tasks.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = Tasks.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = Tasks.change_status(status)
    end
  end
end
