# Progect/main.tf
# Головний файл для підключення та конфігурації модулів VPC та RDS

# Підключення модуля VPC
module "vpc" {
  source = "./modules/vpc"

  # Назва VPC
  vpc_name = "flexible-rds-vpc"
  # CIDR блок для VPC
  vpc_cidr_block = "10.0.0.0/16"
  # CIDR блоки для публічних підмереж (по одній на зону доступності)
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  # CIDR блоки для приватних підмереж (по одній на зону доступності)
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  # Теги для ресурсів VPC
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
}

# Підключення модуля RDS
module "rds" {
  source = "./modules/rds"

  # Використання Aurora замість звичайної RDS (true/false)
  # Змініть на true для Aurora, або false для звичайної RDS
  use_aurora = false # Встановіть false для RDS instance, true для Aurora cluster

  # ID VPC, отриманий з модуля VPC
  vpc_id = module.vpc.vpc_id
  # ID приватних підмереж, отримані з модуля VPC
  private_subnet_ids = module.vpc.private_subnet_ids
  # CIDR блок VPC для налаштування Security Group
  vpc_cidr_block = module.vpc.vpc_cidr_block

  # Конфігурація бази даних
  db_name     = "mydb"
  username    = "admin"
  password    = "StrongPassword123!"
  port        = 5432                 # 5432 для PostgreSQL, 3306 для MySQL

  # Загальні параметри двигуна
  engine         = "postgresql" # postgresql або mysql
  engine_version = "14.7"       # Відповідна версія для обраного двигуна

  # Параметри для RDS Instance (використовуються, якщо use_aurora = false)
  instance_class      = "db.t3.micro" # Клас інстансу для звичайної RDS
  allocated_storage   = 20            # Розмір сховища в ГБ
  multi_az            = false         # Використання Multi-AZ для звичайної RDS
  publicly_accessible = false         # Доступність з публічного інтернету

  # Параметри для Aurora Cluster (використовуються, якщо use_aurora = true)
  cluster_instance_class = "db.t3.medium" # Клас інстансу для Aurora кластера
  backup_retention_period = 7             # Період зберігання резервних копій Aurora в днях
  preferred_backup_window = "03:00-05:00" # Вікно для резервного копіювання Aurora

  # Теги для ресурсів RDS
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
}
