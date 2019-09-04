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
    cloud = "ec2",
    cloud.location = "us-east-1",
    clopud.network = "vpc-0206e948abadc6a29"
  } 
}

variable "lb_subnet" {
    policy = "cloud.subnets"
    conditions = {
    cloud = "ec2"
  }
}
