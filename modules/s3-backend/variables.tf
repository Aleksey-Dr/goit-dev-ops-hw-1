variable "bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  type        = string
}

variable "aws_region" {
  description = "The AWS region for the S3 bucket and DynamoDB table."
  type        = string
}