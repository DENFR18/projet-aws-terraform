resource "aws_security_group" "rds_sg" {
  name   = "rds-sg-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = { Name = "rds-sg-${var.env}" }
}

resource "aws_db_subnet_group" "this" {
  name       = "rds-subnet-group-${var.env}"
  subnet_ids = [var.private_subnet_id, var.private_subnet_b_id]
  tags       = { Name = "rds-subnet-group-${var.env}" }
}

resource "aws_db_instance" "this" {
  identifier        = "rds-${var.env}"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = "admindb"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true
  tags                = { Name = "rds-${var.env}" }
}