variable "db_host" {
  description = "Hostname for the MySQL Database"
}

variable "db_name" {
  description = "Name for the Photos database"
}

variable "db_password" {
  description = "Password to connect to the Photos database"
}

variable "db_username" {
  description = "Username to connect to the Photos database"
}

variable "google_client_id" {
  description = "Client ID for Google OAuth used by Photos"
}

variable "google_client_secret" {
  description = "Client Secret for Google OAuth used by Photos"
}

variable "subdomain" {
  description = "Subdomain where the Photos app will run from"
}