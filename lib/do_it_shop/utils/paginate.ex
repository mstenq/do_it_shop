defmodule DoItShop.Utils.Paginate do
  import Ecto.Query, warn: false

  def paginate(query, %{page: page, per_page: per_page}) do
    offset = max(page - 1, 0) * per_page

    query
    |> limit(^per_page)
    |> offset(^offset)
  end

  def paginate(query, _options), do: query
end
