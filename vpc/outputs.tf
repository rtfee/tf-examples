output "cidr_block" {
  description = "VPC_CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  description = "VPC_ID"
  value       = module.vpc.vpc_id
}
