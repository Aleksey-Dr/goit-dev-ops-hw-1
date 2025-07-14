output "jenkins_url" {
  description = "URL Jenkins Load Balancer"
  value       = module.jenkins.jenkins_url
}

output "jenkins_admin_password" {
  description = "Initial Admin Password for Jenkins"
  value       = module.jenkins.jenkins_admin_password
  sensitive   = true # Позначаємо як чутливу інформацію
}

output "argo_cd_url" {
  description = "URL Argo CD Load Balancer"
  value       = module.argo_cd.argo_cd_url
}

output "argo_cd_initial_password" {
  description = "Initial Admin Password for Argo CD"
  value       = module.argo_cd.argo_cd_initial_password
  sensitive   = true # Позначаємо як чутливу інформацію
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}