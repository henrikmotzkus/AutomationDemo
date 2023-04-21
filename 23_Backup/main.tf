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
}

resource "azurerm_resource_group" "example" {
  name     = "storage_backup-test"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "henriktestbackup"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_data_protection_backup_vault" "example" {
  name                = "example-backup-vault"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.example.identity[0].principal_id
}

resource "azurerm_data_protection_backup_policy_blob_storage" "example" {
  name               = "example-backup-policy"
  vault_id           = azurerm_data_protection_backup_vault.example.id
  retention_duration = "P30D"
}

resource "azurerm_data_protection_backup_instance_blob_storage" "example" {
  name               = "example-backup-instance"
  vault_id           = azurerm_data_protection_backup_vault.example.id
  location           = azurerm_resource_group.example.location
  storage_account_id = azurerm_storage_account.example.id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.example.id

  depends_on = [azurerm_role_assignment.example]
}