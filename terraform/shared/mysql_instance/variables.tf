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
  description = "Region where the DB instance is going to be created."
}

variable "zone" {
  description = "Zone where the DB instance is going to be created."
}
