# Progect/modules/eks/outputs.tf
# Виводи модуля EKS

output "cluster_name" {
  description = "Назва створеного кластера EKS."
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Кінцева точка API сервера Kubernetes."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Дані сертифіката CA для кластера Kubernetes (в Base64)."
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "URL OIDC провайдера для кластера EKS."
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "node_group_name" {
  description = "Назва створеної групи вузлів EKS."
  value       = aws_eks_node_group.main.node_group_name
}

output "node_group_arn" {
  description = "ARN створеної групи вузлів EKS."
  value       = aws_eks_node_group.main.arn
}

output "eks_cluster_security_group_id" {
  description = "ID групи безпеки, пов'язаної з площиною управління EKS кластера."
  value       = aws_security_group.eks_cluster_sg.id
}
