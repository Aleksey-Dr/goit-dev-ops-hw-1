output "bucket_id" {
  value = aws_s3_bucket.tf_state_bucket.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf_state_lock.name
}