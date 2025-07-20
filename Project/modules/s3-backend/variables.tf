# Progect/modules/s3-backend/variables.tf
# Змінні для модуля S3 Backend

variable "bucket_name" {
  description = "Назва S3 бакету для зберігання стану Terraform."
  type        = string
}

variable "dynamodb_table_name" {
  description = "Назва DynamoDB таблиці для блокування стану Terraform."
  type        = string
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів."
  type        = map(string)
  default     = {}
}
