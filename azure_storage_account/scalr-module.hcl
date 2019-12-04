version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "azure"
  }
}

variable "resourcegroup" {
  policy = "azure.resource_groups"
   conditions = {
  cloud = "azure"
  }
}
