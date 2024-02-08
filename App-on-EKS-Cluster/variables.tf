variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet-az1" {
  default = "ap-south-1a"
}

variable "subnet-az2" {
  default = "ap-south-1b"
}

variable "public-subnet1-cidr" {
  default = "10.0.1.0/24"
}

variable "public-subnet2-cidr" {
  default = "10.0.2.0/24"
}

variable "private-subnet1-cidr" {
  default = "10.0.3.0/24"
}

variable "private-subnet2-cidr" {
  default = "10.0.4.0/24"
}

variable "instance_type" {
  default = "t2.medium"
}