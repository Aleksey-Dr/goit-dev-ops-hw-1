output "repository_url" {
  description = "The full URI of the repository."
  value       = aws_ecr_repository.django_app_repo.repository_url
}

output "repository_name" {
  description = "The name of the ECR repository."
  value       = aws_ecr_repository.django_app_repo.name
}