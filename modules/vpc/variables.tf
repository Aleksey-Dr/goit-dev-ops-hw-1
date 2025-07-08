variable "vpc_cidr_block" {
  description = "CIDR-блок для VPC."
  type        = string
}

variable "public_subnets" {
  description = "Список CIDR-блоків для публічних підмереж."
  type        = list(string)
}

variable "private_subnets" {
  description = "Список CIDR-блоків для приватних підмереж."
  type        = list(string)
}

variable "availability_zones" {
  description = "Список зон доступності для розгортання ресурсів."
  type        = list(string)
  default     = ["eu-central-1a, eu-central-1b, eu-central-1c"]
}

variable "vpc_name" {
  description = "Тег імені для VPC."
  type        = string
}