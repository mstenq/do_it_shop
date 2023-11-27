defmodule DoItShopWeb.Components.NavLink do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  attr :navigate, :string, required: true
  attr :current_path, :string, required: true
  attr :class, :string, default: ""
  attr :exact, :boolean, default: false
  attr :active_class, :string, default: "active"

  slot :inner_block, required: true

  def nav_link(assigns) do
    assigns = assign_active_class(assigns)

    ~H"""
    <.link navigate={@navigate} class={[@active_class, @class]}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  def assign_active_class(
        %{navigate: navigate, current_path: current_path, active_class: active_class, exact: true} =
          assigns
      ) do
    active_class = if navigate == current_path, do: active_class, else: ""
    assign(assigns, active_class: active_class)
  end

  def assign_active_class(
        %{navigate: navigate, current_path: current_path, active_class: active_class} = assigns
      ) do
    active_class = if String.starts_with?(current_path, navigate), do: active_class, else: ""
    assign(assigns, active_class: active_class)
  end
end
