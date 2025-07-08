output "vpc_id" {
  description = "Ідентифікатор VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Ідентифікатори публічних підмереж."
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "Ідентифікатори приватних підмереж."
  value       = [for s in aws_subnet.private : s.id]
}