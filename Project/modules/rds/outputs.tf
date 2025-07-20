# Progect/modules/rds/outputs.tf
# Выводы модуля RDS.

# Вывод конечной точки базы данных
output "db_endpoint" {
  description = "Конечная точка (endpoint) базы данных."
  value       = var.use_aurora ? aws_rds_cluster.main[0].endpoint : aws_db_instance.main[0].address
}

# Вывод порта базы данных
output "db_port" {
  description = "Порт базы данных."
  value       = var.use_aurora ? aws_rds_cluster.main[0].port : aws_db_instance.main[0].port
}

# Вывод имени пользователя базы данных
output "db_username" {
  description = "Имя пользователя базы данных."
  value       = var.use_aurora ? aws_rds_cluster.main[0].master_username : aws_db_instance.main[0].username
}

# Вывод имени базы данных
output "db_name" {
  description = "Имя базы данных."
  value       = var.use_aurora ? aws_rds_cluster.main[0].database_name : aws_db_instance.main[0].db_name
}

# Вывод ID группы безопасности базы данных
output "security_group_id" {
  description = "ID группы безопасности базы данных."
  value       = aws_security_group.db_sg.id
}

# Вывод названия группы подсетей базы данных
output "db_subnet_group_name" {
  description = "Название группы подсетей базы данных."
  value       = aws_db_subnet_group.main.name
}

# Вывод ID кластера Aurora (если используется Aurora)
output "aurora_cluster_id" {
  description = "ID Aurora Cluster (если используется Aurora)."
  value       = var.use_aurora ? aws_rds_cluster.main[0].id : null
}

# Вывод ID инстанса RDS (если используется обычная RDS)
output "rds_instance_id" {
  description = "ID RDS Instance (если используется обычная RDS)."
  value       = var.use_aurora ? null : aws_db_instance.main[0].id
}
