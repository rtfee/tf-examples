variable "scalr_azurerm_subscription_id" {}

variable "scalr_azurerm_client_id" {}

variable "scalr_azurerm_client_secret" {}

variable "scalr_azurerm_tenant_id" {}

variable "region" {
default = "East US"
}

variable "storageaccountname" {
description = "Storage Account Name"
}

variable "resourcegroup" {
description = "Resource Group Name"
}
