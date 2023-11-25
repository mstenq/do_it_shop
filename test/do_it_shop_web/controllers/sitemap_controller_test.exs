defmodule DoItShopWeb.SitemapControllerTest do
  use DoItShopWeb.ConnCase

  describe "index" do
    test "displays the sitemap in the correct format", %{conn: conn} do
      conn = get(conn, ~p"/sitemap.xml")

      assert response_content_type(conn, :xml) =~ "charset=utf-8"
      assert response(conn, 200) =~ "<loc>http://localhost:4002/</loc>"
    end
  end
end
