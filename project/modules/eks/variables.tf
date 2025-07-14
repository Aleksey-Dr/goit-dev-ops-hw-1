variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "private_subnets_ids" {
  description = "List of private subnet IDs for EKS node groups."
  type        = list(string)
}

variable "public_subnets_ids" {
  description = "List of public subnet IDs for EKS Load Balancers, etc."
  type        = list(string)
}