version = "v1"

variable "region" {
  policy = "cloud.locations"
  conditions = {
  cloud = "ec2"
  }
}

variable "subnet" {
  policy = "cloud.subnets"
  conditions = {
  cloud = "ec2",
  cloud.location = "${var.region}",
  cloud.network = "vpc-0206e948abadc6a29"
  }
}

variable "instance_type" {
    policy = "cloud.instance.types"
    conditions = {
    cloud = "ec2"
  }
}

variable "sg" {
  policy = "cloud.security_groups"
  conditions = {
  cloud = "ec2"
  }
}
