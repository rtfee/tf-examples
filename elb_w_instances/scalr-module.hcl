version = "v1"

variable "instance_type" {
    policy = "cloud.instance.types"
    conditions = {
    cloud = "ec2"
  }
}

variable "subnet" {
    policy = "cloud.subnets"
    conditions = {
    cloud = "ec2"
  }
}

variable "lb_subnet" {
    policy = "cloud.subnets"
    conditions = {
    cloud = "ec2"
  }
}
