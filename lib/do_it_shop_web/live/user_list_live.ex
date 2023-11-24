defmodule DoItShopWeb.UserListLive do
  use DoItShopWeb, :live_view

  alias DoItShop.Accounts

  def mount(_params, _session, socket) do
    users = Accounts.list_users()

    {:ok, stream(socket, :users, users)}
  end

  def render(assigns) do
    ~H"""
    <div class="prose">
      <h2 class="">Employees</h2>
    </div>

    <div class="bg-base-100 container mt-2 rounded p-8 shadow">
      <div class="flex justify-between">
        <h1>Employees</h1>
        
        <.button>Add Employee</.button>
      </div>
      
      <ul id="users" phx-update="stream">
        <li :for={{dom_id, user} <- @streams.users} id={dom_id}><%= user.email %></li>
      </ul>
    </div>
    """
  end
end
