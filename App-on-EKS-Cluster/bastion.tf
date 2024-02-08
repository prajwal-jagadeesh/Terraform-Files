data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_key_pair" "existing-key-pair" {
  key_name = "webapp"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = data.aws_key_pair.existing-key-pair.key_name
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public-subnet1.id
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]

  tags = {
    Name = "Bastion"
  }
}