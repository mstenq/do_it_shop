defmodule DoItShopWeb.StatusLive.Show do
  use DoItShopWeb, :live_view

  alias DoItShop.Tasks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:status, Tasks.get_status!(id))}
  end

  defp page_title(:show), do: "Show Status"
  defp page_title(:edit), do: "Edit Status"
end
