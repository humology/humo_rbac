defmodule ExcmsRoleWeb.ErrorViewTest do
  use ExcmsServer.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(ExcmsRoleWeb.ErrorView, "404.html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ExcmsRoleWeb.ErrorView, "500.html", []) == "Internal Server Error"
  end
end
