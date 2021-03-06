provider "aws" {
  access_key = "${var.scalr_aws_access_key}"
  secret_key = "${var.scalr_aws_secret_key}"
  region     = var.region
}

resource "aws_eks_cluster" "example" {
  name     = var.eks_name
  role_arn = "arn:aws:iam::670025224396:role/eks"

  vpc_config {
    subnet_ids = ["subnet-0ebb1058ad727cfdb", "subnet-04554823fca3e1f64"]
  }
}

output "endpoint" {
  value = "${aws_eks_cluster.example.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.example.certificate_authority.0.data}"
}
