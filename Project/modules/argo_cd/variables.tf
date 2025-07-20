# Progect/modules/argo_cd/variables.tf
# Змінні для модуля Argo CD Helm.

variable "release_name" {
  description = "Назва релізу Helm для Argo CD."
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "Простір імен Kubernetes, куди буде встановлено Argo CD."
  type        = string
  default     = "argocd"
}

variable "chart_name" {
  description = "Назва Helm чарту для Argo CD."
  type        = string
  default     = "argo-cd"
}

variable "chart_version" {
  description = "Версія Helm чарту для Argo CD."
  type        = string
  default     = "5.36.0" # Перевірте актуальну версію на Artifact Hub або репозиторії
}

variable "chart_repository" {
  description = "URL репозиторію Helm, звідки береться чарт Argo CD."
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
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
