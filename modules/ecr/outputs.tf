output "ecr_repository_url" {
  description = "URL репозиторію ECR."
  value       = aws_ecr_repository.main.repository_url
}