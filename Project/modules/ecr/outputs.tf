# Progect/modules/ecr/outputs.tf
# Виводи модуля ECR

output "repository_arn" {
  description = "ARN (Amazon Resource Name) створеного репозиторію ECR."
  value       = aws_ecr_repository.main.arn
}

output "repository_url" {
  description = "URL створеного репозиторію ECR."
  value       = aws_ecr_repository.main.repository_url
}
