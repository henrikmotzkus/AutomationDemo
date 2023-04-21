resource "azurerm_resource_group" "adds_resource_group" {
  name     = var.resourcegroup_name
  location = var.location
  tags = {
    Environment = var.environment
  }
}

data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}