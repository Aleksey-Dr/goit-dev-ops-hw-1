# Progect/modules/eks/aws_ebs_csi_driver.tf
# Встановлення плагіну AWS EBS CSI Driver для кластера EKS.
# Цей файл налаштовує необхідні ресурси IAM та EKS Addon
# для використання Amazon EBS як сховища для Kubernetes.

# Створення політики IAM для AWS EBS CSI Driver
resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name_prefix = "${var.cluster_name}-ebs-csi-policy"
  description = "IAM політика для AWS EBS CSI Driver на кластері EKS ${var.cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes",
          "ec2:ModifyVolume",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeAvailabilityZones",
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ]
        Resource = "*"
      },
    ]
  })

  tags = var.tags
}

# Створення ролі IAM для AWS EBS CSI Driver
resource "aws_iam_role" "ebs_csi_driver_role" {
  name_prefix        = "${var.cluster_name}-ebs-csi-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      },
    ]
  })

  tags = var.tags
}

# Приєднання політики до ролі IAM
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_role_policy_attach" {
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
  role       = aws_iam_role.ebs_csi_driver_role.name
}

# Отримання даних про поточний AWS акаунт
data "aws_caller_identity" "current" {}

# Встановлення AWS EBS CSI Driver як EKS Addon
resource "aws_eks_addon" "ebs_csi_driver_addon" {
  # Назва кластера EKS
  cluster_name = aws_eks_cluster.main.name
  # Назва доповнення
  addon_name   = "aws-ebs-csi-driver"
  # ARN ролі IAM для доповнення
  service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn

  # Залежність від кластера EKS та ролі IAM
  depends_on = [
    aws_eks_cluster.main,
    aws_iam_role_policy_attachment.ebs_csi_driver_role_policy_attach
  ]
}
