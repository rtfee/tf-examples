variable "scalr_aws_secret_key" {}
variable "scalr_aws_access_key" {}
variable "aws_region" {}
variable "vpc_name" {

  description = "The name of the VPC that will be created to house the EKS cluster."

  type        = string

  default     = "vpc-example"

}

 

variable "eks_cluster_name" {

  description = "The name of the EKS cluster."

  type        = string

  default     = "eks-example"

}

 

# ---------------------------------------------------------------------------------------------------------------------

# OPTIONAL PARAMETERS

# These variables have defaults and may be overwritten

# ---------------------------------------------------------------------------------------------------------------------

 

variable "kubernetes_version" {

  description = "Version of Kubernetes to use. Refer to EKS docs for list of available versions (https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html)."

  type        = string

  default     = "1.13"

}

 

variable "availability_zone_whitelist" {

  description = "A list of availability zones in the region that we can use to deploy the cluster. You can use this to avoid availability zones that may not be able to provision the resources (e.g ran out of capacity). If empty, will allow all availability zones."

  type        = list(string)

  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]

}

 

variable "eks_worker_keypair_name" {

  description = "The public SSH key to be installed on the worker nodes for testing purposes."

  type        = string

  default     = null

}

 

variable "user_data_text" {

  description = "This is purely here for testing purposes. We modify the user_data_text variable at test time to make sure updates to the EKS cluster instances can be rolled out without downtime."

  type        = string

  default     = "Hello World"

}

 

variable "unique_identifier" {

  description = "A unique identifier that can be used to index the test IAM resources"

  type        = string

  default     = ""

}

 

# Kubectl configuration options

 

variable "configure_kubectl" {

  description = "Configure the kubeconfig file so that kubectl can be used to access the deployed EKS cluster."

  type        = bool

  default     = false

}

 

variable "kubectl_config_path" {

  description = "The path to the configuration file to use for kubectl, if var.configure_kubectl is true. Defaults to ~/.kube/config."

  type        = string

 

  # The underlying command will use the default path when empty

  default = ""

}

 

# These variables are only used for testing purposes and should not be touched in normal operations, unless you know

# what you are doing.

 

# NOTE: Setting this to false will prevent your ability to deploy from outside the VPC, requiring VPN to use tools like

# kubectl and helm remotely. You will also be unable to configure the EKS IAM role mapping remotely through this

# terraform code.

variable "endpoint_public_access" {

  description = "Whether or not to enable public API endpoints which allow access to the Kubernetes API from outside of the VPC."

  type        = bool

  default     = true

}

 

variable "configure_openid_connect_provider" {

  description = "Set this to false when using Kubernetes version 1.12"

  type        = bool

  default     = true

}
