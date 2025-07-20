# Progect/modules/vpc/outputs.tf
# Виведення інформації про VPC

output "vpc_id" {
  description = "ID створеної VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID публічних підмереж."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "ID приватних підмереж."
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "CIDR блок VPC."
  value       = aws_vpc.main.cidr_block
}
