provider "aws" {
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region     = var.region
}

resource "aws_organizations_account" "account" {
  name  = var.account_name
  email = var.owner_email
}
