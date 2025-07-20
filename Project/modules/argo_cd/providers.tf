# Progect/modules/argo_cd/providers.tf
# Оголошення провайдерів Terraform для Kubernetes та Helm.
# Ці провайдери необхідні для взаємодії з кластером Kubernetes
# та управління Helm релізами.

# Провайдер Kubernetes
# Він використовує конфігурацію Kubeconfig для підключення до кластера.
provider "kubernetes" {
  # Зазвичай, Terraform автоматично знаходить Kubeconfig з ~/.kube/config
  # або зі змінної середовища KUBECONFIG.
  # Можна вказати явний шлях:
  # config_path = "~/.kube/config"

  # Або використовувати дані з модуля EKS, якщо він буде інтегрований:
  # host                   = module.eks.cluster_endpoint
  # cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  # token                  = data.aws_eks_cluster_auth.main.token
}

# Провайдер Helm
# Він також використовує конфігурацію Kubeconfig для підключення до кластера
# та управління Helm релізами.
provider "helm" {
  # Залежить від провайдера Kubernetes
  kubernetes {
    # Зазвичай, Terraform автоматично знаходить Kubeconfig.
    # Можна вказати явний шлях:
    # config_path = "~/.kube/config"

    # Або використовувати дані з модуля EKS, якщо він буде інтегрований:
    # host                   = module.eks.cluster_endpoint
    # cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    # token                  = data.aws_eks_cluster_auth.main.token
  }
}
