# Kubernetes provider для взаємодії з EKS кластером
provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Helm provider для розгортання Helm чартів
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}