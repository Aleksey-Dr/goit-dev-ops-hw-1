output "s3_bucket_url" {
  description = "URL S3-бакету."
  value       = "s3://${aws_s3_bucket.terraform_state.bucket}"
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB."
  value       = aws_dynamodb_table.terraform_locks.name
}