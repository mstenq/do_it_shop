defmodule DoItShopWeb.Components.NavLink do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  attr :navigate, :string, required: true
  attr :class, :string, default: ""
  attr :exact, :boolean, default: false
  attr :active_class, :string, default: "active"

  slot :inner_block, required: true

  def nav_link(assigns) do
    ~H"""
    <.link
      id={"nav-link-#{@navigate}"}
      phx-hook="NavLink"
      data-exact={to_string(@exact)}
      data-active-class={@active_class}
      navigate={@navigate}
      class={[@class]}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
