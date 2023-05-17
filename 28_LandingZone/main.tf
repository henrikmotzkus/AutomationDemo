data "azurerm_billing_enrollment_account_scope" "prod" {
  billing_account_name    = var.billing_account_name
  enrollment_account_name = var.enrollment_account_name
}

resource "azurerm_subscription" "example" {
  subscription_name = var.subscription_name
  billing_scope_id  = data.azurerm_billing_enrollment_account_scope.prod.id
  tags = {
    Environment = var.environment
  }
  provisioner "local-exec" {
    command = "az login --allow-no-subscriptions --tenant 72f988bf-86f1-41af-91ab-2d7cd011db47"
  }
}

resource "azurerm_resource_group" "networking" {
  name     = var.resourcegroup_name
  location = var.location
  tags = {
    Environment = var.environment
  }
  provider = azurerm.internal
}


resource "azurerm_virtual_network" "virtual_network" {
  name = var.vnet_name
  location = azurerm_resource_group.networking.location
  resource_group_name = azurerm_resource_group.networking.name
  address_space = [var.network_address_space]
 
  tags = {
    Environment = var.environment
  }
  provider = azurerm.internal
}
 
resource "azurerm_subnet" "subnet" {
  name = var.subnet_address_name
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.subnet_address_prefix]
  provider = azurerm.internal
}