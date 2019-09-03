output "cidr_block" {
  description = "VPC CIDR"
  value       = aws_vpc.scalr.cidr_block
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.scalr.id
}

