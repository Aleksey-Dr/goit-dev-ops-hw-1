terraform {
  backend "s3" {
    bucket         = "tf-state-goit-2025-07-14" # Назва S3 бакета (як в файлі main.tf)
    key            = "terraform.tfstate"
    region         = "eu-central-1" # Регіон, де буде знаходитися бакет
    dynamodb_table = "tf-state-lock-table-goit-2025-07-14" # Назва DynamoDB таблиці (як в файлі main.tf)
    encrypt        = true
  }
}