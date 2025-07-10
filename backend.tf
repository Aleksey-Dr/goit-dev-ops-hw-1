terraform {
  backend "s3" {
    # Те саме ім'я, що і в main.tf
    bucket         = "tf-state-aleksey-goit-2025-07-08"
    key            = "lesson-7/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}