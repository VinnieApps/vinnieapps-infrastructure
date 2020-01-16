variable "base_domain_zone_name" {
    description = "Name of the Managed Zone where the subdomains will be created in."
}

variable "db_password" {
  description = "Password to set for the MySQL database"
}

variable "environment" {
    description = "Name of the environment your building."
}

variable "google_client_id" {
  description = "Client ID for Google OAuth used by Photos"
}

variable "google_client_secret" {
  description = "Client Secret for Google OAuth used by Photos"
}

variable "project_id" {
    description = "ID of the Google Cloud Project to be used."
}

variable "region" {
    default = "us-east1"
    description = "Region where the environment is going to be created."
}

variable "zone" {
    default = "us-east1-b"
    description = "Zone used to create the resources."
}
