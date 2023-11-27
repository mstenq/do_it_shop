defmodule DoItShopWeb.EmployeeLive.Show do
  use DoItShopWeb, :live_view
  alias DoItShop.Accounts

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    socket =
      assign(socket,
        employee: Accounts.get_user!(id)
      )

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <.back navigate={~p"/employees"} phx-click="index">Employees</.back>
      
      <:actions>
        <.button class="btn-ghost"><.icon name="hero-plus" />Add Employee</.button>
      </:actions>
    </.header>

    <.content>
      <.header>
        <%= "#{@employee.first_name} #{@employee.last_name}" %>
        <:actions>
          <.dropdown>
            Test
            <:actions><a>Edit</a></:actions>
            
            <:actions><a class="hover:text-error">Delete</a></:actions>
          </.dropdown>
        </:actions>
      </.header>
      
      <dl>
        <dt>Name</dt>
        
        <dd><%= "#{@employee.first_name} #{@employee.last_name}" %></dd>
        
        <dt>Email</dt>
        
        <dd><%= @employee.email %></dd>
        
        <dt>Role</dt>
        
        <dd><%= @employee.role.role %></dd>
      </dl>
    </.content>
    """
  end
end
