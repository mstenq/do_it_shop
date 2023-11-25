defmodule DoItShopWeb.Fallback do
  @moduledoc """
  Use this in a LiveView when a resource is not found.
  ```
  raise DoItShopWeb.Fallback
  ```
  """
  defexception message: "invalid route", plug_status: 404
end