variable "scalr_aws_secret_key" {}
variable "scalr_aws_access_key" {}

variable "region" {
  default = "us-east-1"
}

variable "subnet" {
description = "Subnet ID"
}

variable "sg" {
description = "AWS Security Group"
type = list(string)
}
