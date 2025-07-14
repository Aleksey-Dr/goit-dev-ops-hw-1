output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "kubeconfig_file" {
  description = "Path to the generated kubeconfig file for the EKS cluster."
  value       = local_file.kubeconfig.filename
}

output "eks_openid_connect_provider_arn" {
  description = "The ARN of the OpenID Connect provider for the EKS cluster."
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "local_file" "kubeconfig" {
  content  = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${aws_eks_cluster.main.certificate_authority[0].data}
    server: ${aws_eks_cluster.main.endpoint}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - "eks"
        - "get-token"
        - "--cluster-name"
        - "${aws_eks_cluster.main.name}"
        - "--region"
        - "${data.aws_region.current.name}"
      installHint: |
        The aws-cli must be installed and configured.
EOT
  filename = "${path.module}/kubeconfig_${aws_eks_cluster.main.name}" # Зберігаємо kubeconfig в папці модуля
}

data "aws_region" "current" {} # Для отримання поточної назви регіону