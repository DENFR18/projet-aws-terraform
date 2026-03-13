terraform {
  backend "s3" {
    bucket         = "tfstate-denilsson-projet-aws"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}