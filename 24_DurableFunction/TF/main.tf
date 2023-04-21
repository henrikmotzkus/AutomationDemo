terraform {
  required_version = ">=0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.49.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
     }
  }
}

###### Resource Group
resource "azurerm_resource_group" "resourceGroup1" {
  name     = "${var.ResourceGroupName}"
  location = "${var.ResourceGroupLocation}"
}

###### Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.resourceGroup1.location
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  address_space       = ["10.4.0.0/16"]
}

###### Subnets for App Service instances
resource "azurerm_subnet" "subnet" {
  name                 = "subent"
  resource_group_name  = azurerm_resource_group.resourceGroup1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.4.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

/*
###### Subnets for DNS resolver
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet-dnsresolver"
  resource_group_name  = azurerm_resource_group.resourceGroup1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.4.2.0/24"]
  enforce_private_link_endpoint_network_policies = true
  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}
*/

###### Peering to production VNET
data "azurerm_virtual_network" "prodvnet" {
    name                    = "Hub" 
    resource_group_name     = "Network"
}

data "azurerm_resource_group" "prodrg" {
    name     = "Network"
}

resource "azurerm_virtual_network_peering" "hubtofunction" {
  name                      = "hubtofunction"
  resource_group_name       = data.azurerm_resource_group.prodrg.name
  virtual_network_name      = data.azurerm_virtual_network.prodvnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_forwarded_traffic = true
  allow_gateway_transit = true

}

resource "azurerm_virtual_network_peering" "functiontohub" {
  name                      = "functiontohub"
  resource_group_name       = azurerm_resource_group.resourceGroup1.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.prodvnet.id
  use_remote_gateways = true
}

/*
###### DNS resolver
resource "azurerm_private_dns_resolver" "dnsresolver" {
  name                = "dnsresolver"
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  location            = azurerm_resource_group.resourceGroup1.location
  virtual_network_id  = data.azurerm_virtual_network.prodvnet.id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "dnsresinbound" {
  name                    = "dnsresolverinbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.dnsresolver.id
  location                = azurerm_resource_group.resourceGroup1.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = azurerm_subnet.subnet2.id
  }
}
*/

###### Storage Account
resource "azurerm_storage_account" "storageAccount1" {
  name                     = "${var.StorageAccountName}"
  resource_group_name      = "${azurerm_resource_group.resourceGroup1.name}"
  location                 = "${azurerm_resource_group.resourceGroup1.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

###### private endpoint
resource "azurerm_private_endpoint" "storage-pe" {
  name                = "${azurerm_storage_account.storageAccount1.name}-endpoint"
  location            = azurerm_resource_group.resourceGroup1.location
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  subnet_id           = azurerm_subnet.subnet.id
  private_service_connection {
    name                           = "${azurerm_storage_account.storageAccount1.name}-privateconnection"
    private_connection_resource_id = azurerm_storage_account.storageAccount1.id
    subresource_names = ["file"]
    is_manual_connection = false
  }
}

###### App Service Plan
resource "azurerm_app_service_plan" "appServicePlan1" {
  name                = "${var.AppServicePlanName}"
  location            = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name = "${azurerm_resource_group.resourceGroup1.name}"
  kind                = "elastic"

  sku {
    tier = "ElasticPremium"
    size = "EP1"
  }
}

###### Function App
resource "azurerm_function_app" "functionApp1" {
  name                      = "${var.FunctionAppName}"
  location                  = "${azurerm_resource_group.resourceGroup1.location}"
  resource_group_name       = "${azurerm_resource_group.resourceGroup1.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.appServicePlan1.id}"
  version                   = "~4"
  storage_account_name       = azurerm_storage_account.storageAccount1.name
  storage_account_access_key = azurerm_storage_account.storageAccount1.primary_access_key
}

###### Private Endpoint
resource "azurerm_private_endpoint" "func-pe" {
  name                = "${azurerm_function_app.functionApp1.name}-endpoint"
  location            = azurerm_resource_group.resourceGroup1.location
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  subnet_id           = azurerm_subnet.subnet.id
  private_service_connection {
    name                           = "${azurerm_function_app.functionApp1.name}-privateconnection"
    private_connection_resource_id = azurerm_function_app.functionApp1.id
    subresource_names = ["sites"]
    is_manual_connection = false
  }
}

###### Create Private DNS Zone for files
resource "azurerm_private_dns_zone" "dns-zone" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.resourceGroup1.name
}

####### Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "link_vnl"
  resource_group_name   = azurerm_resource_group.resourceGroup1.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

###### Create DNS A Record
resource "azurerm_private_dns_a_record" "dns_a" {
  name                = azurerm_storage_account.storageAccount1.name
  zone_name           = azurerm_private_dns_zone.dns-zone.name
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage-pe.private_service_connection.0.private_ip_address]
}

###### Create Private DNS Zone for the function
resource "azurerm_private_dns_zone" "dns-zone2" {
  name                = "azurewebsites.net"
  resource_group_name = azurerm_resource_group.resourceGroup1.name
}

####### Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "network_link2" {
  name                  = "link_vnl-2"
  resource_group_name   = azurerm_resource_group.resourceGroup1.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone2.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link3" {
  name                  = "link_vnl-3"
  resource_group_name   = azurerm_resource_group.resourceGroup1.name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone2.name
  virtual_network_id    = data.azurerm_virtual_network.prodvnet.id
}

###### Create DNS A Record
resource "azurerm_private_dns_a_record" "dns_a-2" {
  name                = lower(azurerm_function_app.functionApp1.name)
  zone_name           = azurerm_private_dns_zone.dns-zone2.name
  resource_group_name = azurerm_resource_group.resourceGroup1.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.func-pe.private_service_connection.0.private_ip_address]
}