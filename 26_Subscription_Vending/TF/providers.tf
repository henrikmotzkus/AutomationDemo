terraform {
  required_version = ">=0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.49.0"
    }

    azapi = {
      source = "azure/azapi"
    }


  }
}

provider "azurerm" {
  features {
    resource_group {
       prevent_deletion_if_contains_resources = false
     }
  }
}


provider "azapi" {
}