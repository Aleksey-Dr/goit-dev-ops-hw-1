# Progect/modules/prometheus/outputs.tf
# Виводи для модуля Prometheus Helm Release

output "prometheus_release_name" {
  description = "Назва розгорнутого Helm релізу Prometheus."
  value       = helm_release.kube_prometheus_stack.name
}

output "prometheus_namespace" {
  description = "Простір імен Kubernetes, в якому розгорнуто Prometheus."
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
