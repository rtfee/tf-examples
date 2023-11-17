#provider "github" {
#  token        = var.github_token
#  organization = var.github_organization
#}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.40.0"
    }
  }
}

provider "github" {}

# Configure the GitHub Provider
#provider "github" {
# token = var.token
# organization = var.organization
#}

resource "github_repository" "example" {
  name        = var.repo_name
  description = "My awesome codebase"

  private = false
}
