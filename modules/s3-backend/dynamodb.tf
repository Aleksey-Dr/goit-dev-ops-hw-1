resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.dynamodb_table_name}-locks"
    Environment = "Dev"
  }
}