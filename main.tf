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

module "eks" {
  source              = "./modules/eks"
  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_id   = module.vpc.private_subnet_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
}

module "rds" {
  source              = "./modules/rds"
  env                 = var.env
  vpc_id              = module.vpc.vpc_id
  private_subnet_id   = module.vpc.private_subnet_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  db_password         = var.db_password
}