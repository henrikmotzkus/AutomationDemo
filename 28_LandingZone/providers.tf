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
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
     }
  }
  skip_provider_registration = true
}

provider "azurerm" {
  features {}
  alias           = "internal"
  subscription_id = azurerm_subscription.example.subscription_id
  tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
  skip_provider_registration = true
}