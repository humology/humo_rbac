defmodule ExcmsRoleWeb.Dashboard.UserRoleView do
  use ExcmsRoleWeb, :view

  def roles_options(items) do
    for item <- items do
      {item.name, to_string(item.id)}
    end
  end

  def roles_ids(items) do
    Enum.map(items, & &1.id)
  end

  def roles_names(items) do
    Enum.map(items, & &1.name)
    |> Enum.join(", ")
  end
end
