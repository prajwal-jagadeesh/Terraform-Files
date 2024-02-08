resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Demo-vpc"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.public-subnet1-cidr
  availability_zone       = var.subnet-az1
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.public-subnet2-cidr
  availability_zone = var.subnet-az2
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet2"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "Demo-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table_association" "public-sock1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-sock2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private-subnet1-cidr
  availability_zone = var.subnet-az1

  tags = {
    Name = "Private-subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private-subnet2-cidr
  availability_zone = var.subnet-az2

  tags = {
    Name = "Private-subnet2"
  }
}

resource "aws_eip" "demo-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "demo-natgw" {
  allocation_id = aws_eip.demo-eip.id
  subnet_id     = aws_subnet.public-subnet2.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.demo-natgw.id
  }
}

resource "aws_route_table_association" "private-sock1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-sock2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rt.id
}

module "sgs" {
  source = "./eks-sg"
  vpc_id = aws_vpc.demo-vpc.id
}

module "eks" {
  source     = "./eks"
  vpc_id     = aws_vpc.demo-vpc.id
  subnet_ids = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  sg_ids     = module.sgs.security_group_public
}