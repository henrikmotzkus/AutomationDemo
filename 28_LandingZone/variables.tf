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

variable "subnet_address_prefix" {
  type        = string
}
 
variable "subnet_address_name" {
  type        = string
}

variable "environment" {
    type    = string
}

variable "billing_account_name" {
    type    = string
}

variable "enrollment_account_name" {
    type    = string
}

variable "subscription_name" {
    type    = string
}


