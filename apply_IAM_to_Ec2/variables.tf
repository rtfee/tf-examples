variable "scalr_aws_secret_key" {}
variable "scalr_aws_access_key" {}

variable "region" {
}

variable "subnet" {
description = "Subnet ID"
}

variable "sg" {
description = "AWS Secruity Group"
type = list(string)
}
