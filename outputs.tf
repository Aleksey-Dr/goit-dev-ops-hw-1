output "s3_bucket_url" {
  description = "URL S3-бакету для стану Terraform."
  value       = module.s3_backend.s3_bucket_url
}

output "dynamodb_table_name" {
  description = "Ім'я таблиці DynamoDB для блокування стану Terraform."
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "Ідентифікатор VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Ідентифікатори публічних підмереж."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Ідентифікатори приватних підмереж."
  value       = module.vpc.private_subnet_ids
}

output "ecr_repository_url" {
  description = "URL репозиторію ECR."
  value       = module.ecr.ecr_repository_url
}