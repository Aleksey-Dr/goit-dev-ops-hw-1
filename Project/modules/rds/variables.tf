# Progect/modules/rds/variables.tf
# Змінні для модуля RDS.

variable "use_aurora" {
  description = "Якщо true, створюється Aurora Cluster; якщо false, створюється звичайна RDS Instance."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID VPC, в якій буде розміщена база даних."
  type        = string
}

variable "private_subnet_ids" {
  description = "Список ID приватних підмереж для DB Subnet Group."
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR блок VPC для налаштування Security Group."
  type        = string
}

variable "db_name" {
  description = "Назва бази даних."
  type        = string
}

variable "username" {
  description = "Ім'я користувача для доступу до бази даних."
  type        = string
}

variable "password" {
  description = "Пароль для користувача бази даних."
  type        = string
  sensitive   = true # Позначаємо як чутливу змінну
}

variable "port" {
  description = "Порт бази даних (наприклад, 5432 для PostgreSQL, 3306 для MySQL)."
  type        = number
}

variable "engine" {
  description = "Тип двигуна бази даних (postgresql або mysql)."
  type        = string
}

variable "engine_version" {
  description = "Версія двигуна бази даних."
  type        = string
}

# Змінні для RDS Instance (використовуються, якщо use_aurora = false)
variable "instance_class" {
  description = "Клас інстансу для звичайної RDS Instance (наприклад, db.t3.micro)."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Розмір сховища в ГБ для звичайної RDS Instance."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Чи використовувати Multi-AZ розгортання для звичайної RDS Instance."
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Чи є база даних публічно доступною (НЕ РЕКОМЕНДУЄТЬСЯ для продакшну)."
  type        = bool
  default     = false
}

# Змінні для Aurora Cluster (використовуються, якщо use_aurora = true)
variable "cluster_instance_class" {
  description = "Клас інстансу для Aurora Cluster (наприклад, db.t3.medium)."
  type        = string
  default     = "db.t3.medium"
}

variable "backup_retention_period" {
  description = "Період зберігання резервних копій у днях для Aurora Cluster."
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Вікно для резервного копіювання Aurora Cluster (наприклад, '03:00-05:00')."
  type        = string
  default     = "03:00-05:00"
}

variable "skip_final_snapshot" {
  description = "Чи пропускати створення фінального знімка при видаленні бази даних."
  type        = bool
  default     = true # Встановлено в true для швидшого видалення під час розробки
}

variable "tags" {
  description = "Карта тегів, що застосовуються до ресурсів."
  type        = map(string)
  default     = {}
}
