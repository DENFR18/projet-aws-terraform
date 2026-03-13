variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_id" {
  description = "Subnet privé A — vient du module vpc"
  type        = string
}

variable "private_subnet_b_id" {
  description = "Subnet privé B — vient du module vpc"
  type        = string
}

variable "db_password" {
  description = "Mot de passe BDD — ne jamais le mettre en dur"
  type        = string
  sensitive   = true
}