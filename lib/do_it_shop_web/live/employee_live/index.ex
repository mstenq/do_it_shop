defmodule DoItShopWeb.EmployeeLive.Index do
  use DoItShopWeb, :live_view

  alias Phoenix.LiveView.JS
  alias DoItShop.Tenants
  alias DoItShop.Accounts
  alias DoItShop.Accounts.User

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Accounts.subscribe()
    end

    {:ok, stream(socket, :employees, [])}
  end

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> stream(:employees, Accounts.list_users(params), reset: true)
      |> assign(socket.assigns.live_action, params)
      |> assign(sort_options: params)

    {:noreply, socket}
  end

  defp apply_action(socket, :new, _params) do
    user_changeset = Accounts.change_user_add_to_org(%User{})
    roles = Enum.map(Tenants.list_roles(), fn role -> {role.role, role.id} end)

    socket
    |> assign(:page_title, "New Employee")
    |> assign_form(user_changeset)
    |> assign(:roles, roles)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Employees")
    |> assign(:employee, nil)
  end

  def render(assigns) do
    ~H"""
    <div class="container pb-2">
      <div class="prose">
        <h2 class="">Employees</h2>
      </div>
    </div>

    <div class="bg-base-100 container mt-2 rounded-xl p-8 shadow">
      <div class="flex justify-between">
        <.input type="search" name="search" value="" placeholder="Search" />
        <.link class="btn" patch={~p"/employees/new"}>Add Employee</.link>
      </div>
      
      <.table id="users_table" rows={@streams.employees}>
        <:col :let={{_, employee}} label="Name" click={sort_by(:first_name, @sort_options)}>
          <%= String.capitalize(employee.first_name) <> " " <> String.capitalize(employee.last_name) %>
        </:col>
        
        <:col :let={{_, employee}} label="Email" click={sort_by(:email, @sort_options)}>
          <%= employee.email %>
        </:col>
        
        <:col :let={{_, employee}} label="Role" click={sort_by(:role, @sort_options)}>
          <%= String.capitalize(employee.role.role) %>
        </:col>
      </.table>
    </div>
     <pre><%= inspect(@sort_options, prett: true) %></pre>
    <.modal
      :if={@live_action == :new}
      show
      id="new_employee_modal"
      on_cancel={JS.patch(~p"/employees")}
      max_width="max-w-lg"
    >
      <.new_employee_form form={@form} roles={@roles} />
    </.modal>
    """
  end

  def new_employee_form(assigns) do
    ~H"""
    <div class="prose">
      <h3>Add Employee</h3>
    </div>

    <.simple_form for={@form} id="new_employee_form" phx-submit="save" phx-change="validate">
      <.input
        type="select"
        field={@form[:role_id]}
        label="Role"
        prompt="Select Role"
        phx-debounce="500"
        options={@roles}
      /> <.input field={@form[:first_name]} label="First Name" phx-debounce="500" />
      <.input field={@form[:last_name]} label="Last Name" phx-debounce="500" />
      <.input field={@form[:email]} type="email" label="Email" required phx-debounce="500" />
      <div class="flex gap-2 pt-4">
        <.button class="btn-primary" phx-disable-with="Adding Employee...">
          Add Employee
        </.button>
         <.link class="btn" patch={~p"/employees"}>Cancel</.link>
      </div>
    </.simple_form>
    """
  end

  def assign_form(socket, %Ecto.Changeset{} = changeset) do
    socket
    |> assign(:form, to_form(changeset))
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_add_to_org(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.add_user_to_org(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_new_account_instructions(
            user,
            &url(~p"/users/reset_password/#{&1}")
          )

        {:noreply, push_patch(socket, to: ~p"/employees")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_info({:user_created, user}, socket) do
    {:noreply, stream_insert(socket, :employees, user)}
  end

  def handle_info(message, socket) do
    IO.warn("UNHANDLED MESSAGE: #{inspect(message)}")
    {:noreply, socket}
  end

  def sort_by(key, sortOptions \\ %{}) do
    current_sort_order = sortOptions["sort_order"]
    IO.puts("current_sort_order: #{inspect(current_sort_order)}")
    next_sort_order = if current_sort_order == "asc", do: "desc", else: "asc"
    fn -> JS.patch(~p"/employees?#{%{sort_by: key, sort_order: next_sort_order}}") end
  end
end
