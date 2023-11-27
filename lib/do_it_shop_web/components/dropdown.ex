defmodule DoItShopWeb.Components.Dropdown do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  import DoItShopWeb.CoreComponents

  attr :position, :string,
    default: "dropdown-end",
    values: ~w(dropdown-end dropdown-top dropdown-bottom dropdown-left dropdown-right)

  attr :open_on_hover, :boolean, default: false
  attr :trigger_class, :string, default: ""

  slot :trigger, required: false
  slot :inner_block, required: true

  slot :actions, required: false do
    attr :class, :string
  end

  def dropdown(assigns) do
    ~H"""
    <div class={["dropdown", @position, @open_on_hover && "dropdown-hover"]}>
      <div tabindex="0" role="button" class={["btn", @trigger_class]}>
        <.icon :if={@trigger == []} name="hero-bars-3" /><%= render_slot(@trigger) %>
      </div>
       <%!-- Render any old thing in the dropdown --%>
      <div
        :if={@actions == []}
        class="dropdown-content z-[1] bg-base-100 rounded-box border-base-200 border p-2 shadow-xl"
      >
        <%= render_slot(@inner_block) %>
      </div>
       <%!-- if any actions are passed, render a menu --%>
      <ul
        :if={@actions != []}
        class="dropdown-content z-[1] menu bg-base-100 rounded-box border-base-200 w-52 border p-2 shadow-xl"
      >
        <li :for={action <- @actions} class={action["class"]}><%= render_slot(action) %></li>
      </ul>
    </div>
    """
  end
end
