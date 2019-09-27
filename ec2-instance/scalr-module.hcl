version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "ec2"
  }
}

variable "subnets" {
  policy = "cloud.subnets"
  conditions = {
  cloud = "ec2"
  }
}
