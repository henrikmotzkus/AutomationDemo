provider "cmdb" {
  api_version = "v1"
  hostname = "azuredeployfunction.azurewebsites.net"
}

data "name_allocation" "vm_1_name" {
  provider = "cmdb"

  region = "westeurope"
  resource_type = "COL"
}

data "name_details" "vm_1_details" {
  provider = "cmdb"

  name = data.name_allocation.vm_1_name.name
}

output "vm_1_name" {
  value = data.name_allocation.vm_1_name.name
}

output "vm_1_type" {
  value = data.name_details.vm_1_details.type
}

output "vm_1_details_raw" {
  value = data.name_details.vm_1_details.raw
}