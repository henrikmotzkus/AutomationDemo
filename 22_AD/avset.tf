resource "azurerm_availability_set" "ad_avset" {
  name                = "avset"
  location            = azurerm_resource_group.adds_resource_group.location
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  tags = {
    environment = var.environment
  }
}

resource "azurerm_public_ip" "vm_pub_ip"  {
  for_each = toset(var.vmnames)
  name = "pubip_${each.value}"
  location = azurerm_resource_group.adds_resource_group.location
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  allocation_method   = "Static"
  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vmnames)
  name                = each.value
  location            = azurerm_resource_group.adds_resource_group.location
  resource_group_name = azurerm_resource_group.adds_resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ad_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_pub_ip[each.key].id
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = toset(var.vmnames)
  name                = each.value
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  location            = azurerm_resource_group.adds_resource_group.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.ad_avset.id
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    name                 = "${each.key}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  tags = {
    environment = var.environment
  }

  # identity {
  #   type = "UserAssigned"
  #   identity_ids = [azurerm_user_assigned_identity.avset_identity.id]
  # }

  #identity {
  #  type = "SystemAssigned"
  #}

  #secret {
    #certificate {
    #  store = "MY"
    #  url = azurerm_key_vault_certificate.dsccertificate.secret_id
    #}
    #key_vault_id = azurerm_key_vault.dckeyvault.id
  #}
}

# output "management_host_identity_object_id" {
#   value = azurerm_linux_virtual_machine.management_host.identity.0.principal_id
# }


# resource "azurerm_user_assigned_identity" "avset_identity" {
#   name = "avset_identity"
#   location = azurerm_resource_group.adds_resource_group.location
#   resource_group_name = azurerm_resource_group.adds_resource_group.name
# }

/*
resource "azurerm_role_assignment" "role_assignment_to_managed_id" {
  for_each              = azurerm_windows_virtual_machine.vm
  #scope                = data.azurerm_subscription.primary.id
  scope                 = data.azurerm_subscription.primary.id
  role_definition_name  = "Contributor"
  #principal_id         = azurerm_user_assigned_identity.avset_identity.principal_id
  principal_id          = each.value.identity[0].principal_id
}
*/

/*
resource "azurerm_virtual_machine_extension" "gc" {
  for_each                   = azurerm_windows_virtual_machine.vm
  name                       = "AzurePolicyforWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.GuestConfiguration"
  type                       = "ConfigurationforWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"
}
*/


resource "azurerm_virtual_machine_extension" "installadds" {
  name                 = "installadds"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[var.vmnames[0]].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./install.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/henrikmotzkus/AutomationDemo/main/22_AD/PS/install.ps1"
        ]
    }
  SETTINGS

  tags = {
    environment = var.environment
  }
}


