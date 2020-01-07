version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "gce"
  }
}

variable "instance_type" {
    policy = "cloud.instance.types"
    conditions = {
    cloud = "gce"
  }
}
