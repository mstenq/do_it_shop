defmodule DoItShopWeb.Components.DataItem do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  import DoItShopWeb.CoreComponents

  slot :inner_block, required: true

  def data_item(assigns) do
    ~H"""
    <div>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
