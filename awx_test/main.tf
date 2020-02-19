provider "awx" {
  username = var.username
  password = var.pass
  endpoint = var.endpoint
}

resource "awx_inventory" "terraform" {
  name = "terraform"
  organization_id = 1
}
