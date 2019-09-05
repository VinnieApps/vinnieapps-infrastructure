variable "base_domain_zone_name" {
    description = "Name of the Managed Zone where the subdomains will be created in."
}

variable "db_name" {
    description = "Database name to be created in MySQL"
}

variable "db_password" {
    description = "Password to set for the MySQL database"
}

variable "environment" {
    description = "Name of the environment your building."
}

variable "project_id" {
    description = "ID of the Google Cloud Project to be used."
}

variable "region" {
    default = "us-east1"
    description = "Region where the environment is going to be created."
}

variable "tls_certificate_file" {
    description = "Path to the TLS certificate file"
}

variable "tls_private_key" {
    description = "Path to the TLS private key file"
}

variable "zone" {
    default = "us-east1-b"
    description = "Zone used to create the resources."
}
