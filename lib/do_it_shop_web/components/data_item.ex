defmodule DoItShopWeb.Components.DataItem do
  @moduledoc """
  NavLink components
  """
  use Phoenix.Component

  import DoItShopWeb.CoreComponents

  attr :cols, :string, default: "lg:grid-cols-2"
  slot :inner_block, required: true

  def data_row(assigns) do
    ~H"""
    <div class={[
      "grid grid-cols-1 divide-y border-t dark:divide-zinc-700 dark:border-zinc-700",
      @cols
    ]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :label
  slot :inner_block

  def data_item(assigns) do
    ~H"""
    <div class="space-y-2 py-6">
      <div class="text-sm font-semibold text-zinc-700 dark:text-zinc-400">
        <%= render_slot(@label) %>
      </div>
      
      <div class="leading-7 text-zinc-600 dark:text-zinc-300"><%= render_slot(@inner_block) %></div>
    </div>
    """
  end
end
