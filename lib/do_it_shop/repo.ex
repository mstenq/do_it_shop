defmodule DoItShop.Repo do
  use Ecto.Repo,
    otp_app: :do_it_shop,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @impl true
  def prepare_query(_operation, query, opts) do
    IO.inspect(opts, label: "PREPARE QUERY", pretty: true)

    cond do
      opts[:skip_org_id] || opts[:schema_migration] ->
        {query, opts}

      org_id = opts[:org_id] ->
        {Ecto.Query.where(query, org_id: ^org_id), opts}

      true ->
        raise "expected org_id or skip_org_id to be set"
    end
  end

  @impl true
  def default_options(_operation) do
    [org_id: DoItShop.Store.get_org_id()]
  end

  def set_org(changeset) do
    Ecto.Changeset.put_change(changeset, :org_id, DoItShop.Store.get_org_id())
  end

  def set_created_user_id(changeset) do
    Ecto.Changeset.put_change(changeset, :created_user_id, DoItShop.Store.get_current_user().id)
  end

  def set_default_fields(changeset) do
    changeset
    |> set_org()
    |> set_created_user_id()
  end
end
