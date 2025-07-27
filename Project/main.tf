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

# Підключення модуля ECR
module "ecr" {
  source = "./modules/ecr"
  repository_name = "django-app" # Назва репозиторію
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
}

# Підключення модуля EKS
module "eks" {
  source = "./modules/eks"

  cluster_name = "my-devops-eks-cluster"
  kubernetes_version = "1.28" # Перевірте актуальні версії AWS
  cluster_iam_role_arn = "arn:aws:iam::152710746299:role/EKSClusterRole"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr_block = module.vpc.vpc_cidr_block
  enable_public_endpoint_access = false

  node_instance_types = ["t3.medium"]
  node_iam_role_arn = "arn:aws:iam::152710746299:role/EKSNodeInstanceRole"
  node_group_min_size = 1
  node_group_max_size = 3
  node_group_desired_size = 1

  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
}

# Виклик модуля JENKINS
module "jenkins" {
  source = "./modules/jenkins"
  # release_name = "jenkins" # Використовувати значення за замовчуванням або змінити
  # namespace = "jenkins"   # Використовувати значення за замовчуванням або змінити
  # chart_version = "4.10.0" # Перевірте актуальну версію
  # chart_repository = "https://charts.jenkins.io"
  # set_values = [] # Додаткові значення Helm
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
  # Залежність від EKS кластера, щоб Jenkins розгортався після його готовності
  depends_on = [module.eks]
}

# Виклик модуля ARGO_CD
module "argo_cd" {
  source = "./modules/argo_cd"
  # release_name = "argo-cd" # Використовувати значення за замовчуванням або змінити
  # namespace = "argocd"    # Використовувати значення за замовчуванням або змінити
  # chart_version = "5.36.0" # Перевірте актуальну версію
  # chart_repository = "https://argoproj.github.io/argo-helm"
  # set_values = [] # Додаткові значення Helm
  tags = {
    Environment = "Dev"
    Project     = "FlexibleRDS"
  }
  # Залежність від EKS кластера
  depends_on = [module.eks]
}

# Виклик модуля Prometheus
module "prometheus" {
  source = "./modules/prometheus" # Вам потрібно створити цей модуль
  namespace = "monitoring"
  # ... інші змінні
  depends_on = [module.eks]
}

# Виклик модуля grafana
module "grafana" {
  source = "./modules/grafana" # Вам потрібно створити цей модуль
  namespace = "monitoring"
  # ... інші змінні
  depends_on = [module.prometheus] # Графана залежить від Прометея
}