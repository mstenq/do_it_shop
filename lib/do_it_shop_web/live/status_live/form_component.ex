defmodule DoItShopWeb.StatusLive.FormComponent do
  use DoItShopWeb, :live_component

  alias DoItShop.Tasks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage status records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="status-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:position]} type="number" label="Position" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Status</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{status: status} = assigns, socket) do
    changeset = Tasks.change_status(status)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"status" => status_params}, socket) do
    changeset =
      socket.assigns.status
      |> Tasks.change_status(status_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"status" => status_params}, socket) do
    save_status(socket, socket.assigns.action, status_params)
  end

  defp save_status(socket, :edit, status_params) do
    case Tasks.update_status(socket.assigns.status, status_params) do
      {:ok, status} ->
        notify_parent({:saved, status})

        {:noreply,
         socket
         |> put_flash(:info, "Status updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_status(socket, :new, status_params) do
    case Tasks.create_status(status_params) do
      {:ok, status} ->
        notify_parent({:saved, status})

        {:noreply,
         socket
         |> put_flash(:info, "Status created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
