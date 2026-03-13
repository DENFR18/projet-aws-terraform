variable "vpc_cidr" {
  description = "CIDR block du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "Environnement (dev, prod)"
  type        = string
}

variable "region" {
  type    = string
  default = "eu-west-3"
}