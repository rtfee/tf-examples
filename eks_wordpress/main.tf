# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A EKS CLUSTER WITH EC2 INSTANCES AS WORKERS
# These templates show an example of how to provision an EKS cluster with EC2 instances acting as workers with an
# Autoscaling Group (ASG) to scale the cluster up and down.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
terraform {
  # This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
  required_version = ">= 0.12"
}
 
# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  # The OIDC issuer info was introduced in AWS provider version 2.28
  version = "~> 2.28"
 
  access_key = var.scalr_aws_access_key
  secret_key = var.scalr_aws_secret_key
  region = var.aws_region
}
 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE OUR KUBERNETES AND HELM CONNECTIONS
# Note that we can't configure our Kubernetes connection until EKS is up and running, so we try to depend on the
# resource being created.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
# The provider needs to depend on the cluster being setup. Here we dynamically pull in the information necessary as data
# sources.
provider "kubernetes" {
  version = "~> 1.6"
 
  load_config_file       = false
  host                   = data.template_file.kubernetes_cluster_endpoint.rendered
  cluster_ca_certificate = base64decode(data.template_file.kubernetes_cluster_ca.rendered)
  token                  = data.aws_eks_cluster_auth.kubernetes_token.token
}
 
# Workaround for Terraform limitation where you cannot directly set a depends on directive or interpolate from resources
# in the provider config.
# Specifically, Terraform requires all information for the Terraform provider config to be available at plan time,
# meaning there can be no computed resources. We work around this limitation by creating a template_file data source
# that does the computation.
# See https://github.com/hashicorp/terraform/issues/2430 for more details
data "template_file" "kubernetes_cluster_endpoint" {
  template = module.eks_cluster.eks_cluster_endpoint
}
 
data "template_file" "kubernetes_cluster_ca" {
  template = module.eks_cluster.eks_cluster_certificate_authority
}
 
data "aws_eks_cluster_auth" "kubernetes_token" {
  name = module.eks_cluster.eks_cluster_name
}
 
# ---------------------------------------------------------------------------------------------------------------------
# CREATE A VPC WITH NAT GATEWAY
# We will provision a new VPC because EKS requires a VPC that is tagged to denote that it is shared with Kubernetes.
# Specifically, both the VPC and the subnets that EKS resides in need to be tagged with:
# kubernetes.io/cluster/EKS_CLUSTER_NAME=shared
# This information is used by EKS to allocate ip addresses to the Kubernetes pods.
# ---------------------------------------------------------------------------------------------------------------------
 
module "vpc_app" {
  source = "github.com/gruntwork-io/module-vpc.git//modules/vpc-app?ref=v0.6.0"
 
  vpc_name   = var.vpc_name
  aws_region = var.aws_region
 
  # These tags (kubernetes.io/cluster/EKS_CLUSTERNAME=shared) are used by EKS to determine which AWS resources are
  # associated with the cluster. This information will ultimately be used by the [amazon-vpc-cni-k8s
  # plugin](https://github.com/aws/amazon-vpc-cni-k8s) to allocate ip addresses from the VPC to the Kubernetes pods.
  custom_tags = module.vpc_tags.vpc_eks_tags
 
  public_subnet_custom_tags              = module.vpc_tags.vpc_public_subnet_eks_tags
  private_app_subnet_custom_tags         = module.vpc_tags.vpc_private_app_subnet_eks_tags
  private_persistence_subnet_custom_tags = module.vpc_tags.vpc_private_persistence_subnet_eks_tags
 
  # The IP address range of the VPC in CIDR notation. A prefix of /18 is recommended. Do not use a prefix higher
  # than /27.
  cidr_block = "10.0.0.0/18"
 
  # The number of NAT Gateways to launch for this VPC. For production VPCs, a NAT Gateway should be placed in each
  # Availability Zone (so likely 3 total), whereas for non-prod VPCs, just one Availability Zone (and hence 1 NAT
  # Gateway) will suffice. Warning: You must have at least this number of Elastic IP's to spare.  The default AWS
  # limit is 5 per region, but you can request more.
  num_nat_gateways = 1
}
 
module "vpc_tags" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "github.com/gruntwork-io/terraform-aws-eks.git//modules/eks-vpc-tags?ref=v0.9.6"
  # source = "../../modules/eks-vpc-tags"
 
  eks_cluster_name = var.eks_cluster_name
}
 
# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE EKS CLUSTER IN TO THE VPC
# ---------------------------------------------------------------------------------------------------------------------
 
module "eks_cluster" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "github.com/gruntwork-io/terraform-aws-eks.git//modules/eks-cluster-control-plane?ref=v0.9.6"
  # source = "../../modules/eks-cluster-control-plane"
 
  cluster_name = var.eks_cluster_name
 
  vpc_id                = module.vpc_app.vpc_id
  vpc_master_subnet_ids = local.usable_subnet_ids
 
  kubernetes_version                = var.kubernetes_version
  configure_kubectl                 = var.configure_kubectl
  kubectl_config_path               = var.kubectl_config_path
  configure_openid_connect_provider = var.configure_openid_connect_provider
 
  endpoint_public_access    = var.endpoint_public_access
  enabled_cluster_log_types = ["api"]
 
  # We can't use kubergrunt based verification or the plugin upgrade script if there is no public endpoint access in
  # this example
  use_kubergrunt_verification = var.endpoint_public_access
  use_upgrade_cluster_script  = var.endpoint_public_access
}
 
module "eks_workers" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "github.com/gruntwork-io/terraform-aws-eks.git//modules/eks-cluster-workers?ref=v0.9.6"
  # source = "../../modules/eks-cluster-workers"
 
  cluster_name                 = var.eks_cluster_name
  eks_master_security_group_id = module.eks_cluster.eks_master_security_group_id
 
  autoscaling_group_configurations = {
    asg = {
      # Make the max size twice the min size to allow for rolling out updates to the cluster without downtime
      min_size   = 2
      max_size   = 4
      subnet_ids = local.usable_subnet_ids
      tags       = []
    }
  }
 
  cluster_instance_ami                         = data.aws_ami.eks_worker.id
  cluster_instance_type                        = "t2.micro"
  cluster_instance_keypair_name                = var.eks_worker_keypair_name
  cluster_instance_user_data                   = data.template_file.user_data.rendered
  cluster_instance_associate_public_ip_address = true
 
  vpc_id = module.vpc_app.vpc_id
}
 
# Allowing SSH from anywhere to the worker nodes for test purposes only.
# THIS SHOULD NOT BE DONE IN PROD
resource "aws_security_group_rule" "allow_inbound_ssh_from_anywhere" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_workers.eks_worker_security_group_id
}
 
# Allowing access to node ports on the worker nodes for test purposes only.
# THIS SHOULD NOT BE DONE IN PROD. INSTEAD USE LOAD BALANCERS.
resource "aws_security_group_rule" "allow_inbound_node_port_from_anywhere" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks_workers.eks_worker_security_group_id
}
 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CONFIGURE EKS IAM ROLE MAPPINGS
# We will map AWS IAM roles to RBAC roles in Kubernetes. By doing so, we:
# - allow access to the EKS cluster when assuming mapped IAM role
# - manage authorization for those roles using RBAC role resources in Kubernetes
# At a minimum, we need to provide cluster node level permissions to the IAM role assumed by EKS workers.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
module "eks_k8s_role_mapping" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  source = "github.com/gruntwork-io/terraform-aws-eks.git//modules/eks-k8s-role-mapping?ref=v0.9.6"
  # source = "../../modules/eks-k8s-role-mapping"
 
  eks_worker_iam_role_arns = [module.eks_workers.eks_worker_iam_role_arn]
 
  iam_role_to_rbac_group_mappings = {
    "${data.aws_caller_identity.current.arn}" = ["system:masters"]
  }
 
  config_map_labels = {
    "eks-cluster" = module.eks_cluster.eks_cluster_name
  }
}
