output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_public_a_id" {
  description = "The ID of public subnet A"
  value       = aws_subnet.public_a.id
}

output "subnet_public_b_id" {
  description = "The ID of public subnet B"
  value       = aws_subnet.public_b.id
}

output "subnet_private_app_a_id" {
  description = "The ID of private app subnet A"
  value       = aws_subnet.private_app_a.id
}

output "subnet_private_app_b_id" {
  description = "The ID of private app subnet B"
  value       = aws_subnet.private_app_b.id
}

output "subnet_private_db_a_id" {
  description = "The ID of private db subnet A"
  value       = aws_subnet.private_db_a.id
}

output "subnet_private_db_b_id" {
  description = "The ID of private db subnet B"
  value       = aws_subnet.private_db_b.id
}
