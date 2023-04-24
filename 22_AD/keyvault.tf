/*

resource "azurerm_key_vault" "dckeyvault" {
  name                        = "kv-henrik-${var.environment}"
  location                    = azurerm_resource_group.adds_resource_group.location
  resource_group_name         = azurerm_resource_group.adds_resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  enabled_for_deployment = true

  access_policy {
    tenant_id     = data.azurerm_client_config.current.tenant_id
    object_id     = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get",
    ]
    secret_permissions = [
      "Get",
    ]
    storage_permissions = [
      "Get",
    ]
    certificate_permissions = [
        "Backup", 
        "Create", 
        "Delete", 
        "DeleteIssuers", 
        "Get", 
        "GetIssuers", 
        "Import", 
        "List", 
        "ListIssuers", 
        "ManageContacts", 
        "ManageIssuers", 
        "Purge", 
        "Recover", 
        "Restore", 
        "SetIssuers", 
        "Update"
    ]
  }
}


resource "azurerm_key_vault_access_policy" "adds_policy" {
  for_each      = azurerm_windows_virtual_machine.vm
  key_vault_id  = azurerm_key_vault.dckeyvault.id
  tenant_id     = data.azurerm_client_config.current.tenant_id
  object_id     = each.value.identity[0].principal_id
    key_permissions = [
  ]
  secret_permissions = [
  ]
  storage_permissions = [
  ]
  certificate_permissions = [
      "Get", 
      "GetIssuers", 
      "List", 
      "ListIssuers", 
  ]
}
*/

/*
resource "azurerm_key_vault_access_policy" "client_id_policy" {
  key_vault_id  = azurerm_key_vault.dckeyvault.id
  tenant_id     = data.azurerm_client_config.current.tenant_id
  #object_id     = each.value.identity[0].principal_id
  object_id     = data.azurerm_client_config.current.object_id
    key_permissions = [
    "Get",
  ]
  secret_permissions = [
    "Get",
  ]
  storage_permissions = [
    "Get",
  ]
  certificate_permissions = [
      "Backup", 
      "Create", 
      "Delete", 
      "DeleteIssuers", 
      "Get", 
      "GetIssuers", 
      "Import", 
      "List", 
      "ListIssuers", 
      "ManageContacts", 
      "ManageIssuers", 
      "Purge", 
      "Recover", 
      "Restore", 
      "SetIssuers", 
      "Update"
  ]
}
*/

/*
resource "azurerm_key_vault_certificate" "dsccertificate" {
  name         = "dsccertificate"
  key_vault_id = azurerm_key_vault.dckeyvault.id
  certificate {
    contents = filebase64("/DSC/mypfx.pfx")
    password = var.cert_password
  }
}

*/