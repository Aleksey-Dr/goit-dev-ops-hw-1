# Progect/modules/vpc/variables.tf
# Змінні для модуля VPC

variable "vpc_name" {
  description = "Назва VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR блок для VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Список CIDR блоків для публічних підмереж."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Список CIDR блоків для приватних підмереж."
  type        = list(string)
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів."
  type        = map(string)
  default     = {}
}
