module "lz_vending" {
  source  = "Azure/lz-vending/azurerm"
  version = "3.1.0" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  # Set the default location for resources
  location = "westeurope"

  # subscription variables
  subscription_alias_enabled = true
  subscription_billing_scope = "/providers/Microsoft.Billing/billingAccounts/1234567/enrollmentAccounts/123456"
  subscription_display_name  = "my-subscription-display-name"
  subscription_alias_name    = "my-subscription-alias"
  subscription_workload      = "Production"

  # management group association variables
  subscription_management_group_association_enabled = true
  subscription_management_group_id                  = "Corp"

  # virtual network variables
  virtual_network_enabled = true
  virtual_networks = {
    one = {
      name                    = "my-vnet"
      address_space           = ["192.168.1.0/24"]
      hub_peering_enabled     = true
      hub_network_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-hub-network-rg/providers/Microsoft.Network/virtualNetworks/my-hub-network"
      mesh_peering_enabled    = true
    }
    two = {
      name                    = "my-vnet2"
      location                = "northeurope"
      address_space           = ["192.168.2.0/24"]
      hub_peering_enabled     = true
      hub_network_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-hub-network-rg/providers/Microsoft.Network/virtualNetworks/my-hub-network2"
      mesh_peering_enabled    = true
    }
  }

  # role assignments
  role_assignment_enabled = true
  role_assignments = {
    # using role definition name, created at subscription scope
    contrib_user_sub = {
      principal_id   = "00000000-0000-0000-0000-000000000000"
      definition     = "Contributor"
      relative_scope = ""
    },
    # using a custom role definition
    custdef_sub_scope = {
      principal_id   = "11111111-1111-1111-1111-111111111111"
      definition     = "/providers/Microsoft.Management/MyMg/providers/Microsoft.Authorization/roleDefinitions/ffffffff-ffff-ffff-ffff-ffffffffffff"
      relative_scope = ""
    },
    # using relative scope (to the created or supplied subscription)
    rg_owner = {
      principal_id   = "00000000-0000-0000-0000-000000000000"
      definition     = "Owner"
      relative_scope = "/resourceGroups/MyRg"
    },
  }
}