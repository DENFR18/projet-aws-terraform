variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "db_password" {
  type      = string
  sensitive = true
}