resource "aws_dynamodb_table" "tf_state_lock" {
  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.dynamodb_table_name}-lock"
    Environment = "Dev"
  }
}