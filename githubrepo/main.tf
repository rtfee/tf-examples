#provider "github" {
#  token        = var.github_token
#  organization = var.github_organization
#}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {}

resource "github_repository" "example" {
  name        = var.repo_name
  description = "My awesome codebase"

  private = false
}
