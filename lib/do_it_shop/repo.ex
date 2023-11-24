defmodule DoItShop.Repo do
  use Ecto.Repo,
    otp_app: :do_it_shop,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @tenant_key {__MODULE__, :org_id}

  @impl true
  def prepare_query(_operation, query, opts) do
    IO.puts("################################")
    IO.puts("prepare_query")
    IO.inspect(query)
    IO.puts("################################")
    IO.puts("opts")
    IO.inspect(opts)
    IO.puts("################################")

    cond do
      opts[:skip_org_id] || opts[:schema_migration] ->
        {query, opts}

      org_id = opts[:org_id] ->
        {Ecto.Query.where(query, org_id: ^org_id), opts}

      true ->
        raise "expected org_id or skip_org_id to be set"
    end
  end

  def put_org_id(org_id) do
    IO.inspect("putting org_id: #{org_id}")
    Process.put(@tenant_key, org_id)
  end

  def get_org_id() do
    Process.get(@tenant_key)
  end

  @impl true
  def default_options(_operation) do
    [org_id: get_org_id()]
  end
end
