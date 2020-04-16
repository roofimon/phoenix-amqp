defmodule GenservWeb.PageController do
  use GenservWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
