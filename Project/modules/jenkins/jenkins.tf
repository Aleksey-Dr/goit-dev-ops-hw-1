# Progect/modules/jenkins/jenkins.tf
# Helm release для установки Jenkins.

resource "helm_release" "jenkins" {
  # Назва релізу Helm
  name       = var.release_name
  # Простір імен Kubernetes, куди буде встановлено Jenkins
  namespace  = var.namespace
  # Встановлювати простір імен, якщо він не існує
  create_namespace = true

  # Назва чарту Jenkins
  chart      = var.chart_name
  # Версія чарту Jenkins
  version    = var.chart_version
  # Репозиторій Helm, звідки береться чарт
  repository = var.chart_repository

  # Передача значень з YAML файлу
  values = [
    file("${path.module}/values.yaml")
  ]

  # Передача додаткових значень, якщо вони є
  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.key
      value = set.value
      type  = set.value_type
    }
  }

  # Зачекати, доки всі ресурси будуть готові
  wait = true
  # Таймаут для установки
  timeout = 600

  # Теги для релізу Helm
  # Helm не підтримує прямі теги Terraform, але їх можна використовувати для організації коду
  # та в інших інструментах, що інтегруються з Terraform.
  # tags = var.tags # Закоментовано, оскільки helm_release не має прямої підтримки тегів Terraform
}
