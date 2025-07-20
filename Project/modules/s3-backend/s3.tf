# Progect/modules/s3-backend/s3.tf
# Створення S3 бакету для зберігання стану Terraform

resource "aws_s3_bucket" "terraform_state_bucket" {
  # Назва бакету, передана через змінну
  bucket = var.bucket_name

  # Увімкнення версіонування для захисту від випадкового видалення або перезапису стану
  versioning {
    enabled = true
  }

  # Увімкнення серверного шифрування за замовчуванням (SSE-S3)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Заборона публічного доступу до бакету
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Теги для бакету
  tags = var.tags
}
