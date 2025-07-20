# Progect/modules/jenkins/variables.tf
# Змінні для модуля Jenkins Helm.

variable "release_name" {
  description = "Назва релізу Helm для Jenkins."
  type        = string
  default     = "jenkins"
}

variable "namespace" {
  description = "Простір імен Kubernetes, куди буде встановлено Jenkins."
  type        = string
  default     = "jenkins"
}

variable "chart_name" {
  description = "Назва Helm чарту для Jenkins."
  type        = string
  default     = "jenkins"
}

variable "chart_version" {
  description = "Версія Helm чарту для Jenkins."
  type        = string
  default     = "4.10.0" # Перевірте актуальну версію на Artifact Hub або репозиторії
}

variable "chart_repository" {
  description = "URL репозиторію Helm, звідки береться чарт Jenkins."
  type        = string
  default     = "https://charts.jenkins.io"
}

variable "set_values" {
  description = "Список об'єктів для встановлення додаткових значень Helm (name, value, type)."
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  default = []
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів (якщо підтримується Helm)."
  type        = map(string)
  default     = {}
}
