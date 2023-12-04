defmodule DoItShopWeb.StatusLive.Index do
  use DoItShopWeb, :live_view

  alias DoItShop.Tasks
  alias DoItShop.Tasks.Status

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :task_status, Tasks.list_task_status())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Status")
    |> assign(:status, Tasks.get_status!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Status")
    |> assign(:status, %Status{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Task status")
    |> assign(:status, nil)
  end

  @impl true
  def handle_info({DoItShopWeb.StatusLive.FormComponent, {:saved, status}}, socket) do
    {:noreply, stream_insert(socket, :task_status, status)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    status = Tasks.get_status!(id)
    {:ok, _} = Tasks.delete_status(status)

    {:noreply, stream_delete(socket, :task_status, status)}
  end
end
