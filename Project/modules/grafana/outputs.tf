# Progect/modules/grafana/outputs.tf
# Виводи для модуля Grafana Helm Release

output "grafana_release_name" {
  description = "Назва розгорнутого Helm релізу Grafana."
  value       = helm_release.grafana.name
}

output "grafana_namespace" {
  description = "Простір імен Kubernetes, в якому розгорнуто Grafana."
  value       = var.namespace
}
