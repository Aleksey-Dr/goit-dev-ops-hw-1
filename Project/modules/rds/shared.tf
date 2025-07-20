# Progect/modules/rds/shared.tf
# Спільні ресурси для RDS Instance та Aurora Cluster.
# Включає DB Subnet Group, Security Group та Parameter Group.

# Створення DB Subnet Group
resource "aws_db_subnet_group" "main" {
  # Назва групи підмереж
  name        = "${var.db_name}-subnet-group"
  # Опис групи підмереж
  description = "Група підмереж для RDS ${var.db_name}"
  # ID приватних підмереж, де буде розміщена база даних
  subnet_ids  = var.private_subnet_ids

  # Теги для групи підмереж
  tags = merge(var.tags, {
    Name = "${var.db_name}-subnet-group"
  })
}

# Створення Security Group для доступу до бази даних
resource "aws_security_group" "db_sg" {
  # Назва групи безпеки
  name        = "${var.db_name}-sg"
  # Опис групи безпеки
  description = "Дозволити вхідний трафік до RDS ${var.db_name}"
  # ID VPC, до якої належить група безпеки
  vpc_id      = var.vpc_id

  # Правило для вхідного трафіку (ingress)
  ingress {
    # Порт бази даних
    from_port   = var.port
    to_port     = var.port
    # Протокол TCP
    protocol    = "tcp"
    # Дозволити доступ з CIDR блоку VPC
    cidr_blocks = [var.vpc_cidr_block]
    # Опис правила
    description = "Дозволити доступ до БД з VPC"
  }

  # Правило для вихідного трафіку (egress)
  egress {
    # Дозволити весь вихідний трафік
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Усі протоколи
    cidr_blocks = ["0.0.0.0/0"] # Дозволити до всіх IP адрес
  }

  # Теги для групи безпеки
  tags = merge(var.tags, {
    Name = "${var.db_name}-sg"
  })
}

# Умовне створення Parameter Group для звичайної RDS Instance
resource "aws_db_parameter_group" "rds_pg" {
  # Створюється, якщо use_aurora = false
  count = var.use_aurora ? 0 : 1

  # Назва групи параметрів
  name   = "${var.db_name}-${var.engine}-pg"
  # Сімейство двигуна бази даних
  family = var.engine == "postgresql" ? "postgres${split(".", var.engine_version)[0]}" : "${var.engine}${split(".", var.engine_version)[0]}"
  # Опис групи параметрів
  description = "Параметри для RDS ${var.db_name} (${var.engine})"

  # Параметри бази даних
  parameter {
    name  = "max_connections"
    value = "100" # Максимальна кількість з'єднань
  }

  parameter {
    name  = "log_statement"
    value = "none" # Рівень логування операторів
  }

  parameter {
    name  = "work_mem"
    value = "4MB" # Обсяг пам'яті для операцій сортування/хешування
  }

  # Теги для групи параметрів
  tags = merge(var.tags, {
    Name = "${var.db_name}-${var.engine}-pg"
  })
}

# Умовне створення Cluster Parameter Group для Aurora Cluster
resource "aws_rds_cluster_parameter_group" "aurora_pg" {
  # Створюється, якщо use_aurora = true
  count = var.use_aurora ? 1 : 0

  # Назва групи параметрів кластера
  name   = "${var.db_name}-${var.engine}-cluster-pg"
  # Сімейство двигуна бази даних
  family = var.engine == "postgresql" ? "aurora-postgresql${split(".", var.engine_version)[0]}" : "aurora-mysql${split(".", var.engine_version)[0]}"
  # Опис групи параметрів кластера
  description = "Параметри для Aurora Cluster ${var.db_name} (${var.engine})"

  # Параметри бази даних
  parameter {
    name  = "max_connections"
    value = "100" # Максимальна кількість з'єднань
  }

  parameter {
    name  = "log_statement"
    value = "none" # Рівень логування операторів
  }

  parameter {
    name  = "work_mem"
    value = "4MB" # Обсяг пам'яті для операцій сортування/хешування
  }

  # Теги для групи параметрів кластера
  tags = merge(var.tags, {
    Name = "${var.db_name}-${var.engine}-cluster-pg"
  })
}
