provider "aws" {
  region  = "ap-south-1"
  profile = "terraform-user"
}

terraform {
  backend "s3" {
    bucket         = "eks-remote-backend"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}