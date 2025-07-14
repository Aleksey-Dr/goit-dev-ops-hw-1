resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = "jenkins"
  create_namespace = true
  version    = "4.10.0" # Перевірте актуальну версію чарту
  values     = [file("${path.module}/values.yaml")]

  depends_on = [
    aws_iam_role_policy.jenkins_sa_policy,
    aws_iam_policy.jenkins_ecr_access
  ]
}

# AWS IAM Role for Jenkins Service Account (for Kaniko to push to ECR)
resource "aws_iam_role" "jenkins_sa_role" {
  name = "jenkins-k8s-sa-role-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "${var.eks_openid_connect_provider_arn}:aud"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.eks_openid_connect_provider_arn, "arn:aws:iam::${var.aws_account_id}:oidc-provider/", "")}:sub" = "system:serviceaccount:jenkins:jenkins-agent"
          }
        }
      },
    ]
  })
}

# Policy for Jenkins SA to allow ECR push access
resource "aws_iam_policy" "jenkins_ecr_access" {
  name        = "jenkins-ecr-push-policy-${var.cluster_name}"
  description = "Allows Jenkins agent to push images to ECR"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Effect   = "Allow"
        Resource = "*" # Обмежте це до конкретного ECR репозиторію для продакшну
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_sa_ecr_attach" {
  role       = aws_iam_role.jenkins_sa_role.name
  policy_arn = aws_iam_policy.jenkins_ecr_access.arn
}

# Kubernetes Service Account (linked to AWS IAM Role)
resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = "jenkins"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.jenkins_sa_role.arn
    }
  }
}

# Kubernetes Cluster Role Binding for Jenkins
resource "kubernetes_cluster_role_binding" "jenkins_admin_binding" {
  metadata {
    name = "jenkins-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin" # Даємо повні права для Jenkins. Обмежте для продакшну!
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins" # Jenkins Master Service Account
    namespace = "jenkins"
  }
}