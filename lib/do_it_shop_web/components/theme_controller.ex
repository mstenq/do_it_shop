defmodule DoItShopWeb.Components.ThemeController do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  import DoItShopWeb.CoreComponents

  def theme_controller(assigns) do
    ~H"""
    <label class="swap swap-rotate">
      <!-- this hidden checkbox controls the state -->
      <input
        id="theme-toggle"
        phx-hook="ThemeToggle"
        type="checkbox"
        class="theme-controller"
        value="dark"
      />
      <!-- sun icon -->
      <.icon name="hero-sun" class="swap-on" />
      <!-- moon icon -->
      <.icon name="hero-moon" class="swap-off" />
    </label>
    """
  end
end
