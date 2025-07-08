variable "ecr_name" {
  description = "Назва репозиторію ECR."
  type        = string
}

variable "scan_on_push" {
  description = "Увімкнути сканування при відправленні образів."
  type        = bool
  default     = true
}