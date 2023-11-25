defmodule DoItShopWeb.EmailHTML do
  @moduledoc """
  This viewmodule is responsible for rendering the emails and the layouts.
  Can be used in the notifier by adding:

      DoItShop.Mailer

  Or:

      import Swoosh.Email
      import DoItShop.Mailer, only: [base_email: 0, premail: 1, render_body: 3]

  """
  use DoItShopWeb, :html

  embed_templates "emails/*.html"
  embed_templates "emails/*.text", suffix: "_text"
end
