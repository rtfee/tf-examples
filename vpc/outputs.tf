output "cidr_block" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
