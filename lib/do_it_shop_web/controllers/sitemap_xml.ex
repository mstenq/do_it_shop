defmodule DoItShopWeb.SitemapXML do
  @moduledoc false
  use DoItShopWeb, :html

  embed_templates "sitemap_xml/*"
end
