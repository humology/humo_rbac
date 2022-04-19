defmodule ExcmsRole.RBACAuthorizationTest do
  use ExcmsRole.DataCase

  alias ExcmsRole.RBACAuthorization
  alias ExcmsRole.RolesService.Role
  alias ExcmsRole.RolesService.Resource

  describe "from_roles/1" do
    test "when roles is empty list, no permission" do
      assert %RBACAuthorization{
               is_administrator: false,
               authorized_resource_actions: %{}
             } = RBACAuthorization.from_roles([])
    end

    test "when roles has administrator role, is_administrator is true" do
      roles = [
        %Role{
          name: "full_role_access",
          resources: [
            %Resource{
              name: "excms_role_roles",
              actions: ["create", "read", "update", "delete"]
            }
          ]
        },
        %Role{name: "administrator", resources: []}
      ]

      assert %RBACAuthorization{
               is_administrator: true,
               authorized_resource_actions: %{}
             } = RBACAuthorization.from_roles(roles)
    end

    test "when list of roles provided, they are united" do
      roles = [
        %Role{
          name: "read_access",
          resources: [
            %Resource{name: "pages", actions: ["read"]},
            %Resource{name: "users", actions: ["read"]}
          ]
        },
        %Role{
          name: "read_page_access",
          resources: [%Resource{name: "pages", actions: ["read"]}]
        },
        %Role{
          name: "update_users_access",
          resources: [%Resource{name: "users", actions: ["update"]}]
        }
      ]

      assert %RBACAuthorization{
               is_administrator: false,
               authorized_resource_actions: %{
                 "pages" => ["read"],
                 "users" => ["read", "update"]
               }
             } = RBACAuthorization.from_roles(roles)
    end
  end
end
