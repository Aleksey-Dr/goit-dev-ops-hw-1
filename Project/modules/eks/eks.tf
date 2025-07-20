# Progect/modules/eks/eks.tf
# Створення кластера Amazon Elastic Kubernetes Service (EKS).
# Цей файл визначає основний ресурс EKS кластера.

resource "aws_eks_cluster" "main" {
  # Назва кластера EKS
  name     = var.cluster_name
  # Версія Kubernetes для кластера
  version  = var.kubernetes_version
  # ARN ролі IAM, яку EKS буде використовувати для створення ресурсів AWS
  role_arn = var.cluster_iam_role_arn

  # Конфігурація VPC для кластера EKS
  vpc_config {
    # ID підмереж, в яких буде розгорнутий кластер EKS
    subnet_ids = var.private_subnet_ids
    # Увімкнути чи публічний доступ до кінцевої точки API сервера Kubernetes
    # Рекомендується залишити false для продакшну та використовувати приватний доступ.
    endpoint_public_access  = var.enable_public_endpoint_access
    # Увімкнути чи приватний доступ до кінцевої точки API сервера Kubernetes
    endpoint_private_access = true
    # ID груп безпеки, які будуть застосовані до ENI, створених EKS у ваших підмережах.
    # Це дозволяє керувати мережевим доступом до API сервера EKS.
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  # Конфігурація логів для кластера EKS
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Теги для кластера EKS
  tags = var.tags

  # Залежність від ролі IAM для кластера
  depends_on = [
    var.cluster_iam_role_arn,
    aws_security_group.eks_cluster_sg
  ]
}

# Створення групи безпеки для кластера EKS
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Група безпеки для площини управління кластера EKS"
  vpc_id      = var.vpc_id

  # Правило для вхідного трафіку: дозволити доступ до API сервера EKS з VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Дозволити доступ до Kubernetes API з VPC"
  }

  # Правило для вихідного трафіку: дозволити весь вихідний трафік
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Дозволити весь вихідний трафік"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
  })
}

# Створення групи вузлів (Node Group) для кластера EKS
resource "aws_eks_node_group" "main" {
  # Назва групи вузлів
  node_group_name = "${var.cluster_name}-node-group"
  # Назва кластера EKS, до якого відноситься група вузлів
  cluster_name    = aws_eks_cluster.main.name
  # Тип інстансів для вузлів
  instance_types  = var.node_instance_types
  # ID підмереж, в яких будуть розгорнуті вузли
  subnet_ids      = var.private_subnet_ids
  # ARN ролі IAM, яку будуть використовувати вузли
  node_role_arn   = var.node_iam_role_arn

  # Конфігурація масштабування
  scaling_config {
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
    desired_size = var.node_group_desired_size
  }

  # Конфігурація віддаленого доступу до вузлів (не рекомендується для продакшну)
  # remote_access {
  #   ec2_ssh_key = "your-ssh-key-name"
  #   source_security_group_ids = ["sg-xxxxxxxxxxxxxxxxx"]
  # }

  # Теги для групи вузлів
  tags = merge(var.tags, {
    Name = "${var.cluster_name}-node-group"
  })

  # Залежність від кластера EKS та ролі IAM для вузлів
  depends_on = [
    aws_eks_cluster.main,
    var.node_iam_role_arn
  ]
}
