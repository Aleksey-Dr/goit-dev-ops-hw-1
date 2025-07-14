output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id]
}

output "private_subnets_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_1.id]
}