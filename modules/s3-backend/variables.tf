variable "bucket_name" {
  description = "Назва S3-бакету для зберігання файлів стану Terraform."
  type        = string
}

variable "table_name" {
  description = "Назва таблиці DynamoDB для блокування стану."
  type        = string
}