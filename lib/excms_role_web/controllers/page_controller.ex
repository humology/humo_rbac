defmodule ExcmsRoleWeb.PageController do
  use ExcmsRoleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
