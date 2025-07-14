variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the EKS cluster."
  type        = string
}

variable "helm_charts_repo_url" {
  description = "URL of the Git repository containing Helm charts (e.g., https://github.com/user/repo.git)."
  type        = string
}