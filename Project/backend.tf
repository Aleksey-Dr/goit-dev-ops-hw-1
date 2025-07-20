# Progect/backend.tf
# Налаштування бекенду S3 для зберігання стану Terraform та DynamoDB для блокування стану
# Важливо: S3 бакет та DynamoDB таблиця повинні бути створені до першого terraform init
# Цей файл використовує модуль s3-backend для їх створення

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Визначення регіону AWS
provider "aws" {
  region = "eu-central-1" # Змініть на бажаний регіон
}

# Підключення модуля для створення S3 бакету та DynamoDB таблиці для бекенду
module "s3_backend" {
  source = "./modules/s3-backend"

  # Назва бакету S3 для зберігання стану Terraform
  bucket_name = "my-devops-terraform-state-bucket-12345" # Унікальна назва бакету
  # Назва таблиці DynamoDB для блокування стану Terraform
  dynamodb_table_name = "my-devops-terraform-state-lock" # Унікальна назва таблиці
  # Теги для ресурсів
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
}

# Конфігурація S3 бекенду.
# Цей блок повинен бути закоментований під час першого `terraform init`,
# якщо S3 бакет та DynamoDB таблиця ще не існують.
# Після створення S3 бакету та DynamoDB таблиці за допомогою `module "s3_backend"`,
# розкоментуйте цей блок та виконайте `terraform init` ще раз.
/*
terraform {
  backend "s3" {
    bucket         = "my-devops-terraform-state-bucket-12345" # Повинно співпадати з bucket_name у модулі s3_backend
    key            = "terraform.tfstate"
    region         = "eu-central-1" # Повинно співпадати з регіоном провайдера
    dynamodb_table = "my-devops-terraform-state-lock" # Повинно співпадати з dynamodb_table_name у модулі s3_backend
    encrypt        = true
  }
}
*/
