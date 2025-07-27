# Progect/modules/prometheus/variables.tf
# Змінні для модуля Prometheus Helm Release

variable "release_name" {
  description = "Назва Helm релізу для Prometheus (kube-prometheus-stack)."
  type        = string
  default     = "kube-prometheus-stack"
}

variable "namespace" {
  description = "Простір імен Kubernetes, куди буде розгорнуто Prometheus."
  type        = string
  default     = "monitoring"
}

variable "chart_name" {
  description = "Назва Helm чарту для Prometheus."
  type        = string
  default     = "kube-prometheus-stack"
}

variable "chart_version" {
  description = "Версія Helm чарту Prometheus."
  type        = string
  default     = "59.2.0" # Рекомендується використовувати конкретну версію
}

variable "chart_repository" {
  description = "URL репозиторію Helm для Prometheus."
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "set_values" {
  description = "Додаткові значення, які будуть передані Helm чарту за допомогою --set прапора."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "string") # Може бути string, boolean, int, etc.
  }))
  default = []
}

variable "tags" {
  description = "Теги для ресурсів AWS, створених цим модулем (якщо застосовні до Kubernetes ресурсів через провайдер AWS)."
  type        = map(string)
  default     = {}
}
