provider "aws" {
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region     = var.region
}

<<<<<<< HEAD
module "vpc" "scalr" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = var.cidr

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.2.0.0/28", "10.2.0.16/28", "10.2.0.32/28"]
=======
resource "aws_vpc" "scalr" {
  cidr_block = var.cidr
>>>>>>> 4fd23c12d87947509814ff7799601f9b897cc7f0

  tags = {
    Name = var.name
  }
}
