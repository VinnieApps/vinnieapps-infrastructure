variable "db_name" {
  description = "Database name to be created in MySQL"
}

variable "db_password" {
  description = "Password to set for the MySQL database"
}

variable "environment" {
  description = "Name of the environment your building."
}

variable "region" {
  default = "us-east1"
  description = "Region where the environment is going to be created."
}
