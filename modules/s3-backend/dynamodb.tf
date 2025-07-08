resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # Або "PROVISIONED" з одиницями пропускної здатності читання/запису
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.table_name}-lock"
    Environment = "Dev"
  }
}