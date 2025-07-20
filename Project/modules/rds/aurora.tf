# Progect/modules/rds/aurora.tf
# Ресурси для створення Aurora Cluster.
# Цей файл використовується, коли змінна use_aurora встановлена в true.

resource "aws_rds_cluster" "main" {
  # Створюється, якщо use_aurora = true
  count = var.use_aurora ? 1 : 0

  # Ідентифікатор кластера БД
  cluster_identifier      = "${var.db_name}-cluster"
  # Тип двигуна бази даних
  engine                  = var.engine
  # Версія двигуна бази даних
  engine_version          = var.engine_version
  # Назва бази даних
  database_name           = var.db_name
  # Ім'я користувача для доступу до БД
  master_username         = var.username
  # Пароль для користувача БД
  master_password         = var.password
  # Порт бази даних
  port                    = var.port
  # Назва групи підмереж БД
  db_subnet_group_name    = aws_db_subnet_group.main.name
  # ID груп безпеки VPC
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  # Назва групи параметрів кластера
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg[0].name
  # Чи створювати фінальний знімок при видаленні кластера
  skip_final_snapshot     = var.skip_final_snapshot
  # Період зберігання резервних копій у днях
  backup_retention_period = var.backup_retention_period
  # Вікно для резервного копіювання
  preferred_backup_window = var.preferred_backup_window

  # Теги для кластера БД
  tags = merge(var.tags, {
    Name = "${var.db_name}-cluster"
  })
}

resource "aws_rds_cluster_instance" "main" {
  # Створюється, якщо use_aurora = true
  count = var.use_aurora ? 1 : 0 # Можна збільшити для більшої кількості інстансів у кластері

  # Ідентифікатор інстансу кластера
  identifier              = "${var.db_name}-cluster-instance-${count.index}"
  # ID кластера БД
  cluster_identifier      = aws_rds_cluster.main[0].id
  # Тип інстансу
  instance_class          = var.cluster_instance_class
  # Тип двигуна
  engine                  = var.engine
  # Версія двигуна
  engine_version          = var.engine_version
  # Зона доступності
  availability_zone       = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids)) # Розподіл по зонах доступності

  # Теги для інстансу кластера
  tags = merge(var.tags, {
    Name = "${var.db_name}-cluster-instance-${count.index}"
  })
}
