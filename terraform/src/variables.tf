variable "app_image" {
  type    = string
  default = "ubuntu:latest"
}

variable "db_image" {
  type    = string
  default = "postgres:16"
}

variable "pg_db" {
  type    = string
  default = "appdb"
}

variable "pg_user" {
  type    = string
  default = "appuser"
}

variable "pg_password" {
  type    = string
  default = "supersecret"
}

variable "pg_port_internal" {
  type    = number
  default = 5432
}

variable "pg_port_external" {
  type    = number
  default = 5433
}

variable "pg_version" {
  type = string
  default = "16"
}


