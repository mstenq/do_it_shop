defmodule DoItShopWeb.ComponentLibrary do
  defmacro __using__(_) do
    quote do
      import DoItShopWeb.Components.{NavLink, ThemeController}
    end
  end
end
