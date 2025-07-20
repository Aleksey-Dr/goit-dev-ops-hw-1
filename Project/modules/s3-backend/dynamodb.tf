# Progect/modules/s3-backend/dynamodb.tf
# Створення DynamoDB таблиці для блокування стану Terraform

resource "aws_dynamodb_table" "terraform_state_lock" {
  # Назва таблиці, передана через змінну
  name         = var.dynamodb_table_name
  # Основний ключ для таблиці
  hash_key     = "LockID"
  # Пропускна здатність для читання
  read_capacity  = 5
  # Пропускна здатність для запису
  write_capacity = 5

  # Атрибути таблиці
  attribute {
    name = "LockID"
    type = "S" # Тип даних: String
  }

  # Теги для таблиці
  tags = var.tags
}
