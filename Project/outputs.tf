# Progect/outputs.tf
# Загальні виводи ресурсів, створених Terraform

# Вивід ID VPC
output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}

# Вивід ID публічних підмереж
output "public_subnet_ids" {
  description = "ID публічних підмереж"
  value       = module.vpc.public_subnet_ids
}

# Вивід ID приватних підмереж
output "private_subnet_ids" {
  description = "ID приватних підмереж"
  value       = module.vpc.private_subnet_ids
}

# Вивід кінцевої точки бази даних
output "db_endpoint" {
  description = "Кінцева точка (endpoint) бази даних"
  value       = module.rds.db_endpoint
}

# Вивід порту бази даних
output "db_port" {
  description = "Порт бази даних"
  value       = module.rds.db_port
}

# Вивід імені користувача бази даних
output "db_username" {
  description = "Ім'я користувача бази даних"
  value       = module.rds.db_username
}

# Вивід імені бази даних
output "db_name" {
  description = "Ім'я бази даних"
  value       = module.rds.db_name
}

# Вивід ID групи безпеки бази даних
output "db_security_group_id" {
  description = "ID групи безпеки бази даних"
  value       = module.rds.security_group_id
}

# Вивід назви групи підмереж бази даних
output "db_subnet_group_name" {
  description = "Назва групи підмереж бази даних"
  value       = module.rds.db_subnet_group_name
}
