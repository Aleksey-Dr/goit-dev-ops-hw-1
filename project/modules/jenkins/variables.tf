variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the EKS cluster."
  type        = string
}

variable "eks_openid_connect_provider_arn" {
  description = "The ARN of the OpenID Connect provider for the EKS cluster."
  type        = string
}

variable "aws_account_id" {
  description = "Your AWS Account ID."
  type        = string
}