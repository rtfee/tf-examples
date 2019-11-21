  
provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
  region     = var.region
}

resource "aws_ec2_capacity_reservation" "default" {
  instance_type     = "t2.micro"
  instance_platform = "Linux/UNIX"
  availability_zone = "us-east-1a"
  instance_count    = 20
}
