defmodule DoItShop.Utils.Sort do
  import Ecto.Query, warn: false

  @doc """
  Sorts a query by the given parameters. Allows for setting default sort,
  allowed, and overrides for related or computed fields.
  """
  def sort(query, params, default_sort, allowed, overrides) do
    params = validate(params, default_sort, allowed)
    sort_by(query, params, overrides)
  end

  @doc """
  Validates the sort_by and sort_order parameters. If sort_by is not in the
  allowed list, it will be set to the default. If sort_order is not asc or
  desc, it will be set to asc.
  """
  def validate(params, default, allowed) do
    params
    |> valid_sort_by(default, allowed)
    |> valid_sort_order()
  end

  # Validate the sort by field is in the allowed list. If not, set it to the default.
  defp valid_sort_by(%{"sort_by" => sort_by} = params, default, allowed) do
    if sort_by in allowed do
      Map.put(params, "sort_by", String.to_existing_atom(sort_by))
    else
      Map.put(params, "sort_by", default)
    end
  end

  defp valid_sort_by(params, default, _allowed) do
    Map.put(params, "sort_by", default)
  end

  # Validate the sort order is asc or desc. If not, set it to asc.
  defp valid_sort_order(%{"sort_order" => sort_order} = params) when sort_order in ~w(asc desc) do
    %{params | "sort_order" => String.to_existing_atom(sort_order)}
  end

  defp valid_sort_order(params) do
    Map.put(params, "sort_order", :asc)
  end

  # Construct the query using the validated sort params
  defp sort_by(query, %{"sort_by" => sort_by, "sort_order" => sort_order}, overrides) do
    override = overrides[sort_by]

    if override do
      query |> order_by(^override) |> maybe_reverse(sort_order)
    else
      query |> order_by({^sort_order, ^sort_by})
    end
  end

  defp sort_by(query, _options, _overrides), do: query

  # If the sort_order is desc, reverses the proxy. Only useful because the sort overrides are a bitch.
  defp maybe_reverse(query, :desc) do
    query |> reverse_order()
  end

  defp maybe_reverse(query, _), do: query

  def next_sort(sort_key, %{"sort_by" => sort_by, "sort_order" => sort_order}) do
    if sort_key == sort_by && sort_order == "asc" do
      %{sort_by: sort_key, sort_order: :desc}
    else
      %{sort_by: sort_key, sort_order: :asc}
    end
  end

  def next_sort(sort_key, _) do
    %{sort_by: sort_key, sort_order: :asc}
  end
end
