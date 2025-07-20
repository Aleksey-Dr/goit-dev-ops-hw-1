# Progect/modules/ecr/ecr.tf
# Створення репозиторію AWS Elastic Container Registry (ECR).
# Цей файл визначає ресурс ECR репозиторію для зберігання образів Docker.

resource "aws_ecr_repository" "main" {
  # Назва репозиторію ECR, передається через змінну
  name = var.repository_name

  # Конфігурація сканування образів
  image_scanning_configuration {
    # Увімкнути сканування образів під час їх завантаження
    scan_on_push = true
  }

  # Конфігурація змінюваності тегів образів
  # MUTABLE: Теги можуть бути перезаписані (за замовчуванням)
  # IMMUTABLE: Теги не можуть бути перезаписані після завантаження образу
  image_tag_mutability = "IMMUTABLE" # Рекомендується для продакшну

  # Теги для репозиторію ECR
  tags = var.tags
}
