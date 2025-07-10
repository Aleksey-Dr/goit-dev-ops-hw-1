variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS node group."
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the EKS cluster endpoint/LoadBalancer."
  type        = list(string)
}

variable "instance_types" {
  description = "A list of instance types for the EKS node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_capacity" {
  description = "The desired number of worker nodes."
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "The maximum number of worker nodes."
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "The minimum number of worker nodes."
  type        = number
  default     = 2
}