version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "azure"
  }
}

variable "rg" {
  policy = "azure.resource_groups"
}
