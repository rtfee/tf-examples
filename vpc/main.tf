provider "aws" {
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region     = var.region
}

resource "aws_vpc" "scalr" {
  cidr_block = var.cidr
}

  tags = {
    Name = var.name
  }
}
