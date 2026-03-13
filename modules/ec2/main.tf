# Récupère la dernière AMI Ubuntu 22.04
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Clé SSH
resource "aws_key_pair" "this" {
  key_name   = "key-${var.env}"
  public_key = var.public_key
}

# Security Group — SSH + HTTP
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #trivy:ignore:AVD-AWS-0107
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #trivy:ignore:AVD-AWS-0107
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg-ec2-${var.env}" }
}

# Instance EC2
resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.this.key_name

  root_block_device {
    encrypted = true
  }

  tags = { Name = "ec2-${var.env}" }
}