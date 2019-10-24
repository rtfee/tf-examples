output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.role-test.id
}

output "public_ip" {
  description = "Public IP"
  value       = aws_instance.role-test.public_ip
}

output "private_ip" {
  description = "Private IP"
  value       = aws_instance.role-test.private_ip
}

output "iam_instance_profile" {
  description = "IAM Instance Profile Name"
  value       = aws_iam_instance_profile.test_profile.name
}
