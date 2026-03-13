terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  region = var.region
}

module "ec2" {
  source        = "./modules/ec2"
  env           = var.env
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  instance_type = "t3.micro"
  public_key = var.public_key
}

module "rds" {
  source              = "./modules/rds"
  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  private_subnet_id   = module.vpc.private_subnet_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  db_password         = var.db_password
}