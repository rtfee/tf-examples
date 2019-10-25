provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
  region     = var.region
}

resource "aws_eks_cluster" "example" {
  name     = var.eks_name
  role_arn = "eks_role"

  vpc_config {
    subnet_ids = ["subnet-0ebb1058ad727cfdb", "subnet-06d3008268a524d69"]
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.example.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.example.certificate_authority.0.data}"
}
