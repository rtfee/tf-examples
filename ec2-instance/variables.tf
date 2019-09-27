variable "region" {
  default = "us-east-1"
}

variable "scalr_aws_secret_key" {}

variable "scalr_aws_access_key" {}

variable "ami" {
  default = "ami-2757f631"
}

variable "instance_type" {
  default = "t2.nano"
}

variable "subnet" {
description = "Subnet ID"
}

variable "key" {
description = "AWS Key"
}
