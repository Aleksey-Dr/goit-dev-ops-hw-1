# Progect/modules/eks/variables.tf
# Змінні для модуля EKS.

variable "cluster_name" {
  description = "Назва кластера EKS."
  type        = string
}

variable "kubernetes_version" {
  description = "Версія Kubernetes для кластера EKS."
  type        = string
  default     = "1.28" # Рекомендована версія, перевірте актуальні версії AWS
}

variable "cluster_iam_role_arn" {
  description = "ARN ролі IAM, яку EKS використовуватиме для створення ресурсів AWS."
  type        = string
}

variable "vpc_id" {
  description = "ID VPC, в якій буде розгорнутий кластер EKS."
  type        = string
}

variable "private_subnet_ids" {
  description = "Список ID приватних підмереж для кластера EKS та груп вузлів."
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR блок VPC для налаштування Security Group кластера EKS."
  type        = string
}

variable "enable_public_endpoint_access" {
  description = "Чи дозволяти публічний доступ до кінцевої точки API сервера Kubernetes."
  type        = bool
  default     = false # Рекомендується false для продакшну
}

variable "node_instance_types" {
  description = "Список типів інстансів для вузлів EKS."
  type        = list(string)
  default     = ["t3.medium"] # Змініть на відповідні типи інстансів
}

variable "node_iam_role_arn" {
  description = "ARN ролі IAM, яку використовуватимуть вузли EKS."
  type        = string
}

variable "node_group_min_size" {
  description = "Мінімальна кількість інстансів у групі вузлів EKS."
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Максимальна кількість інстансів у групі вузлів EKS."
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Бажана кількість інстансів у групі вузлів EKS."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів."
  type        = map(string)
  default     = {}
}
