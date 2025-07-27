# Progect/modules/prometheus/prometheus.tf
# Розгортання Prometheus за допомогою Helm чарту
# Цей файл створює Kubernetes Namespace та Helm Release для Prometheus

# Створення Kubernetes Namespace для Prometheus
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

# Додавання репозиторію Helm для Prometheus
resource "helm_repository" "kube_prometheus_stack" {
  name = "prometheus-community"
  url  = var.chart_repository
}

# Розгортання Prometheus Helm Release
resource "helm_release" "kube_prometheus_stack" {
  name       = var.release_name
  repository = helm_repository.kube_prometheus_stack.name
  chart      = var.chart_name
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = var.chart_version
  values = [prometheus.tf
    file("${path.module}/values.yaml")
  ]

  # Передача додаткових значень, якщо вони є
  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  # Залежність від Kubernetes Namespace
  depends_on = [
    kubernetes_namespace.monitoring
  ]
}
