resource "azurerm_storage_account" "configurations" {
  name                     = "henrikconfigurations"
  resource_group_name      = azurerm_resource_group.adds_resource_group.name
  location                 = azurerm_resource_group.adds_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
 
resource "azurerm_storage_container" "files" {
  name                  = "files"
  storage_account_name  = azurerm_storage_account.configurations.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "configblobs" {
  for_each = fileset(path.module, "DSC/*.zip")
  name                   = trim(each.key, "DSC/")
  storage_account_name   = azurerm_storage_account.configurations.name
  storage_container_name = azurerm_storage_container.files.name
  type                   = "Block"
  source                 = each.key
}

