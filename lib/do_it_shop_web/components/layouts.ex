defmodule DoItShopWeb.Layouts do
  @moduledoc false
  use DoItShopWeb, :html

  embed_templates "layouts/*"

  defp app_nav_items do
    [
      %{label: "Dashboard", icon: "hero-home", path: ~p"/"},
      ## Insert app nav items below ##
    ]
  end
end
