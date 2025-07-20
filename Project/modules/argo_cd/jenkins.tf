# Progect/modules/argo_cd/jenkins.tf
# Helm release для установки Argo CD.
# Примітка: Назва файлу "jenkins.tf" в модулі argo_cd може бути помилковою.
# Зазвичай, цей файл називається argo_cd.tf або release.tf.
# Цей файл налаштовує Helm реліз для Argo CD.

resource "helm_release" "argo_cd" {
  # Назва релізу Helm для Argo CD
  name       = var.release_name
  # Простір імен Kubernetes, куди буде встановлено Argo CD
  namespace  = var.namespace
  # Встановлювати простір імен, якщо він не існує
  create_namespace = true

  # Назва чарту Argo CD
  chart      = var.chart_name
  # Версія чарту Argo CD
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
}
