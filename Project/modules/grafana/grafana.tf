# Progect/modules/grafana/grafana.tf
# Розгортання Grafana за допомогою Helm чарту
# Цей модуль може бути використаний окремо або як частина kube-prometheus-stack
# Якщо Grafana вже включена в kube-prometheus-stack, цей модуль може не знадобитися

# Примітка: Цей модуль передбачає, що простір імен 'monitoring' вже існує
# (наприклад, створений модулем Prometheus, якщо використовується kube-prometheus-stack)

# Додавання репозиторію Helm для Grafana
resource "helm_repository" "grafana" {
  name = "grafana"
  url  = var.chart_repository
}

# Розгортання Grafana Helm Release
resource "helm_release" "grafana" {
  name       = var.release_name
  repository = helm_repository.grafana.name
  chart      = var.chart_name
  namespace  = var.namespace
  version    = var.chart_version
  values = [
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

  # Залежність від існування простору імен (якщо він не створюється цим модулем)
  # depends_on = [kubernetes_namespace.monitoring] # Якщо ви створили namespace деінде
}
