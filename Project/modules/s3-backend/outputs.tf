# Progect/modules/s3-backend/outputs.tf
# Виведення інформації про S3 бакет та DynamoDB таблицю

output "s3_bucket_id" {
  description = "ID S3 бакету."
  value       = aws_s3_bucket.terraform_state_bucket.id
}

output "dynamodb_table_name" {
  description = "Назва DynamoDB таблиці."
  value       = aws_dynamodb_table.terraform_state_lock.name
}
