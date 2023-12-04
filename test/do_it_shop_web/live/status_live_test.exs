defmodule DoItShopWeb.StatusLiveTest do
  use DoItShopWeb.ConnCase

  import Phoenix.LiveViewTest
  import DoItShop.TasksFixtures

  @create_attrs %{position: 42, title: "some title"}
  @update_attrs %{position: 43, title: "some updated title"}
  @invalid_attrs %{position: nil, title: nil}

  defp create_status(_) do
    status = status_fixture()
    %{status: status}
  end

  describe "Index" do
    setup [:create_status]

    test "lists all task_status", %{conn: conn, status: status} do
      {:ok, _index_live, html} = live(conn, ~p"/task_status")

      assert html =~ "Listing Task status"
      assert html =~ status.title
    end

    test "saves new status", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/task_status")

      assert index_live |> element("a", "New Status") |> render_click() =~
               "New Status"

      assert_patch(index_live, ~p"/task_status/new")

      assert index_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#status-form", status: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/task_status")

      html = render(index_live)
      assert html =~ "Status created successfully"
      assert html =~ "some title"
    end

    test "updates status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, ~p"/task_status")

      assert index_live |> element("#task_status-#{status.id} a", "Edit") |> render_click() =~
               "Edit Status"

      assert_patch(index_live, ~p"/task_status/#{status}/edit")

      assert index_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#status-form", status: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/task_status")

      html = render(index_live)
      assert html =~ "Status updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, ~p"/task_status")

      assert index_live |> element("#task_status-#{status.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task_status-#{status.id}")
    end
  end

  describe "Show" do
    setup [:create_status]

    test "displays status", %{conn: conn, status: status} do
      {:ok, _show_live, html} = live(conn, ~p"/task_status/#{status}")

      assert html =~ "Show Status"
      assert html =~ status.title
    end

    test "updates status within modal", %{conn: conn, status: status} do
      {:ok, show_live, _html} = live(conn, ~p"/task_status/#{status}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Status"

      assert_patch(show_live, ~p"/task_status/#{status}/show/edit")

      assert show_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#status-form", status: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/task_status/#{status}")

      html = render(show_live)
      assert html =~ "Status updated successfully"
      assert html =~ "some updated title"
    end
  end
end
