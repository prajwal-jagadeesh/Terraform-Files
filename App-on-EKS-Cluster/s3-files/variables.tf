variable "region" {
  default = "ap-south-1"
}

variable "bucket-name" {
  default = "eks-remote-backend"
}

variable "dynamodb-name" {
  default = "terraform-state-lock"
}