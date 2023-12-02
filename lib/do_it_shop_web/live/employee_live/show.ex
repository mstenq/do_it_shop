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
    <div class="z-[1] bg-base-100 sticky top-0 -mx-3 -mt-3 flex items-center justify-between overflow-hidden border-b border-l pl-4 dark:border-zinc-800 sm:-mx-4 sm:-mt-4 md:-mx-8 md:-mt-8">
      <.back navigate={~p"/employees"} phx-click="index">Employees</.back>
      
      <div id="scroll-spy-menu" phx-hook="ScrollSpy" class="relative flex">
        <a href="#details" class="menu-item ">
          Details
        </a>
        
        <a href="#time-entries" class="menu-item ">
          Time Entries
        </a>
         <a href="#pto" class="menu-item ">PTO</a>
        <a href="#tasks" class="menu-item ">
          Tasks
        </a>
         <div id="scroll-indicator" />
      </div>
    </div>

    <%!-- <.header>
      <.back navigate={~p"/employees"} phx-click="index">Employees</.back>
    
      <:actions>
        <.button class="btn-ghost"><.icon name="hero-plus" />Add Employee</.button>
      </:actions>
    </.header> --%>
    <div class="mt-8 flex flex-col gap-8 xl:flex-row">
      <.content id="details" class="flex-grow w-full">
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
        
        <.data_row cols="grid-cols-1 lg:grid-cols-3">
          <.data_item>
            <:label>Name</:label>
             <%= "#{@employee.first_name} #{@employee.last_name}" %>
          </.data_item>
          
          <.data_item>
            <:label>Email</:label>
             <%= @employee.email %>
          </.data_item>
          
          <.data_item>
            <:label>Role</:label>
             <%= @employee.role.role %>
          </.data_item>
        </.data_row>
        
        <.data_row cols="grid-cols-1">
          <.data_item>
            <:label>Notes</:label>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam vel risus libero. Nullam sagittis congue elit, sed semper arcu mattis nec. Donec fringilla velit non lacus pretium sagittis. Aliquam convallis lacinia turpis sit amet aliquam. Pellentesque dictum interdum lacus, ac gravida quam lacinia non. Nullam at felis et quam posuere placerat. Donec at egestas erat. Mauris est eros, consectetur ac est sit amet, interdum dignissim ipsum. Fusce finibus nulla quis rhoncus pretium. Fusce aliquam urna leo, quis pretium odio maximus eu.
          </.data_item>
        </.data_row>
      </.content>
      
      <.content class="xl:min-w-[300px]">
        Photo
      </.content>
    </div>

    <.content id="time-entries" class="mt-8 h-96">
      <.header>Time Entries</.header>
    </.content>

    <.content id="pto" class="mt-8 h-96">
      <.header>PTO</.header>
    </.content>

    <.content id="tasks" class="mt-8 h-96">
      <.header>Tasks</.header>
    </.content>
    """
  end
end
