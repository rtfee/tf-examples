variable "scalr_aws_secret_key" {}

variable "scalr_aws_access_key" {}

variable "region" {
  description = "Region"
}

variable "instance_type" {
  description = "Instance Type"
}

variable "subnet" {
description = "Subnet ID"
}

variable "sg" {
  description = "AWS Secruity Group"
  type        = list(string)
}

variable "key" {
  description = "AWS Key"
}

variable "vpc_id" {
description = "VPC"
}

variable "ami" {
  description = "AMI"
}
