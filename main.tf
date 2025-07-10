# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source = "./modules/s3-backend"
  bucket_name = "tf-state-aleksey-goit-2025-07-08"
  dynamodb_table_name  = "terraform-locks"
  aws_region  = "eu-central-1"
}

# Підключаємо модуль VPC
module "vpc" {
  source = "./modules/vpc"
  project_name = "goit-devops-lesson-7"
  vpc_cidr                = "10.0.0.0/16"
  public_subnets_cidr     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr    = ["10.0.4.0/24", "10.0.5.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b"]
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  repository_name = "django-goit-app"
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  cluster_name     = "goit-django-eks-cluster"
  vpc_id           = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets_id
  public_subnet_ids  = module.vpc.public_subnets_id
  instance_types   = ["t3.medium"]
  desired_capacity = 2
  max_capacity     = 4
  min_capacity     = 2
}