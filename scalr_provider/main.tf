provider "scalr" {
  hostname = var.scalrserver
  token    = var.token
}

resource "scalr_workspace" "test" {
  name         = var.workspace_name
  organization = var.org
  auto_apply = "true"
  terraform_version = "0.12.19"
  vcs_repo {
     identifier = "scalr-eap/ec2_instance"
     oauth_token_id = var.vcs_id
    }
}
