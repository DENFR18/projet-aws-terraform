variable "env" {
  type = string
}

variable "vpc_id" {
  description = "ID du VPC — vient du module vpc"
  type        = string
}

variable "subnet_id" {
  description = "Subnet public — vient du module vpc"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}