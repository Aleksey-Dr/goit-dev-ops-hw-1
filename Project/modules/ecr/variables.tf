# Progect/modules/ecr/variables.tf
# Змінні для модуля ECR

variable "repository_name" {
  description = "Назва репозиторію ECR."
  type        = string
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів."
  type        = map(string)
  default     = {}
}
