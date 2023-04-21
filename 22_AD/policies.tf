/*
resource "azurerm_resource_policy_assignment" "guest_config_policy_assignment" {
  for_each                = azurerm_windows_virtual_machine.vm
  name                    = "guest_config_${each.value.name}"
  resource_id             = each.value.id
  policy_definition_id    = "/providers/Microsoft.Authorization/policyDefinitions/385f5831-96d4-41db-9a3c-cd3af78aaae6"
  location                = each.value.location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "role_assignment_to_id" {
  for_each = azurerm_resource_policy_assignment.guest_config_policy_assignment
  scope                 = data.azurerm_subscription.primary.id
  role_definition_name  = "Contributor"
  principal_id          = azurerm_resource_policy_assignment.guest_config_policy_assignment[each.key].identity[0].principal_id
}

*/

/*
resource "azurerm_resource_group_policy_assignment" "guest_config_policy_assignment" {
  name                    = "guest_config_for_adds"
  resource_group_id       = azurerm_resource_group.adds_resource_group.id
  policy_definition_id    = "/providers/Microsoft.Authorization/policyDefinitions/385f5831-96d4-41db-9a3c-cd3af78aaae6"
  location                = azurerm_resource_group.adds_resource_group.location
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.avset_identity.id]
  }
}
*/

############# DSC Config in VM deployen
resource "azurerm_policy_virtual_machine_configuration_assignment" "dc_config" {
  for_each = azurerm_windows_virtual_machine.vm
  name                    = "dc_config_${each.value.name}"
  location                = each.value.location
  virtual_machine_id      = each.value.id
  configuration {
    content_uri         =  azurerm_storage_blob.configblobs["DSC/${lower(each.key)}.zip"].url
    version             = "1.0"
    assignment_type     = "ApplyAndMonitor"
    content_hash        = "${filesha256("DSC/${lower(each.key)}.zip")}"
  }
}
