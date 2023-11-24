defmodule DoItShopWeb.Layouts do
  use DoItShopWeb, :html

  embed_templates "layouts/*"

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :test, "hello world")}
  end
end
