defmodule DoItShop.Store do
  @org_id_key {__MODULE__, :org_id}

  def put_org_id(org_id) do
    Process.put(@org_id_key, org_id)
  end

  def get_org_id() do
    Process.get(@org_id_key)
  end

  @current_user_key {__MODULE__, :current_user}
  def put_current_user(user = %DoItShop.Accounts.User{}) do
    Process.put(@current_user_key, user)
  end

  def get_current_user() do
    Process.get(@current_user_key)
  end
end
