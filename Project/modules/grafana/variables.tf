# Progect/modules/grafana/variables.tf
# Змінні для модуля Grafana Helm Release

variable "release_name" {
  description = "Назва Helm релізу для Grafana."
  type        = string
  default     = "grafana"
}

variable "namespace" {
  description = "Простір імен Kubernetes, куди буде розгорнуто Grafana."
  type        = string
  default     = "monitoring"
}

variable "chart_name" {
  description = "Назва Helm чарту для Grafana."
  type        = string
  default     = "grafana"
}

variable "chart_version" {
  description = "Версія Helm чарту Grafana."
  type        = string
  default     = "7.0.0" # Рекомендується використовувати конкретну версію
}

variable "chart_repository" {
  description = "URL репозиторію Helm для Grafana."
  type        = string
  default     = "https://grafana.github.io/helm-charts"
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
