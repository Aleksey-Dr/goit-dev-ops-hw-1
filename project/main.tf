terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# --- Модулі інфраструктури ---

module "s3_backend" {
  source = "./modules/s3-backend"
  bucket_name = "tf-state-goit-2025-07-14"
  dynamodb_table_name = "tf-state-lock-table-goit-2025-07-14"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name = "goit-devops-lesson-8-9"
  vpc_cidr                = "10.0.0.0/16"
  public_subnets_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr    = ["10.0.4.0/24", "10.0.5.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = "django-app-repo"
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "goit-django-eks-cluster-2025-07-14"
  vpc_id = module.vpc.vpc_id
  private_subnets_ids = module.vpc.private_subnets_ids
  public_subnets_ids = module.vpc.public_subnets_ids

  instance_types   = ["t3.medium"]
  desired_capacity = 2
  max_capacity     = 4
  min_capacity     = 2
}

# --- Модулі розгортання застосунків ---

module "jenkins" {
  source = "./modules/jenkins"
  depends_on = [module.eks] # Залежність від успішного розгортання EKS
  cluster_name = module.eks.cluster_name
  kubeconfig_path = module.eks.kubeconfig_file # Шлях до файлу kubeconfig
  # Передача IAM ролі для Jenkins Service Account для Kaniko
  eks_openid_connect_provider_arn = module.eks.eks_openid_connect_provider_arn
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "argo_cd" {
  source = "./modules/argo_cd"
  depends_on = [module.eks] # Залежність від успішного розгортання EKS
  cluster_name = module.eks.cluster_name
  kubeconfig_path = module.eks.kubeconfig_file
  helm_charts_repo_url = "https://github.com/Aleksey-Dr/helm-charts-repo" # URL репозиторію з Helm-чартами
}

# --- Data Sources (для отримання інформації) ---
data "aws_caller_identity" "current" {}