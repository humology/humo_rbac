defmodule HumoRBACWeb.PageController do
  use HumoRBACWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
