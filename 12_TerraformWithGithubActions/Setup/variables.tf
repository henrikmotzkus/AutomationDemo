#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "westeurope"
}

variable "naming_prefix" {
  type    = string
  default = "HenrikAutomation"
}

variable "github_repository" {
  type    = string
  default = "AutomationDemo"
}