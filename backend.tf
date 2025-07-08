terraform {
  backend "s3" {
    # Те саме ім'я, що і в main.tf
    bucket         = "tf-state-aleksey-goit-2025-07-08"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1" # Переконайтеся, що це відповідає вашому регіону AWS
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}