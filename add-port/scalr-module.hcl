version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "ec2"
  }
  }

variable "org" {
  global_variable = "org"
}
