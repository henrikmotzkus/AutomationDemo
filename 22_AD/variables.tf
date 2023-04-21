variable "resourcegroup_name" {
  type = string
}

variable "vnet_name" {
    type    = string
}
 
variable "location" {
    type = string
    default = "westeurope"
}
 
variable "network_address_space" {
    type    = string
}

variable "ad_subnet_address_prefix" {
  type        = string
}
 
variable "ad_subnet_address_name" {
  type        = string
}

variable "environment" {
    type    = string
}

variable "admin_username" {
  type  = string
  default = "adminlocal"
}

variable "admin_password" {
  type  = string
}

variable "vmnames" {
    type    =   list(string)
}

variable "cert_password" {
  type = string  
}