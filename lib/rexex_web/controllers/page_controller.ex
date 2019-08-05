defmodule RexexWeb.PageController do
  use RexexWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
