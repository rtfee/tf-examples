provider "awx" {
#  username = var.username
#  password = var.pass
#  endpoint = var.endpoint
}

#resource "awx_inventory" "terraform" {
#  name = "terraform"
#  organization_id = 2
#}

resource "awx_team" "automation_team" {
        name = "automation_team"
        description = "Automation team"
        organization_id = 1
}
