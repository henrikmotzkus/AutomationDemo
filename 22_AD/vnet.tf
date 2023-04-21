resource "azurerm_virtual_network" "virtual_network" {
  name = var.vnet_name
  location = azurerm_resource_group.adds_resource_group.location
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  address_space = [var.network_address_space]
 
  tags = {
    Environment = var.environment
  }
}
 
resource "azurerm_subnet" "ad_subnet" {
  name = var.ad_subnet_address_name
  resource_group_name  = azurerm_resource_group.adds_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.ad_subnet_address_prefix]
}