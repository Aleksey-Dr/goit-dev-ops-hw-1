# Progect/modules/rds/rds.tf
# Ресурси для створення звичайної RDS Instance.
# Цей файл використовується, коли змінна use_aurora встановлена в false.

resource "aws_db_instance" "main" {
  # Створюється, якщо use_aurora = false
  count = var.use_aurora ? 0 : 1

  # Назва бази даних
  db_name                = var.db_name
  # Ідентифікатор інстансу БД
  identifier             = "${var.db_name}-instance"
  # Тип двигуна бази даних
  engine                 = var.engine
  # Версія двигуна бази даних
  engine_version         = var.engine_version
  # Клас інстансу
  instance_class         = var.instance_class
  # Розмір сховища в ГБ
  allocated_storage      = var.allocated_storage
  # Ім'я користувача для доступу до БД
  username               = var.username
  # Пароль для користувача БД
  password               = var.password
  # Порт бази даних
  port                   = var.port
  # Назва групи підмереж БД
  db_subnet_group_name   = aws_db_subnet_group.main.name
  # ID груп безпеки VPC
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  # Назва групи параметрів БД
  parameter_group_name   = aws_db_parameter_group.rds_pg[0].name
  # Чи є інстанс публічно доступним
  publicly_accessible    = var.publicly_accessible
  # Чи створювати фінальний знімок при видаленні інстансу
  skip_final_snapshot    = var.skip_final_snapshot
  # Чи використовувати Multi-AZ розгортання
  multi_az               = var.multi_az
  # Період зберігання резервних копій у днях
  backup_retention_period = 7 # За замовчуванням 7 днів для RDS Instance
  # Вікно для резервного копіювання
  preferred_backup_window = "03:00-05:00" # За замовчуванням

  # Теги для інстансу БД
  tags = merge(var.tags, {
    Name = "${var.db_name}-instance"
  })
}
