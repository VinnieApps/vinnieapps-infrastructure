variable "environment" {
  description = "Name of the environment your building."
}

variable "subdomain" {
  description = "Sub domain name where the application will be exposed"
}

variable "tls_certificate" {
  description = "Content of the TLS certificate"
}

variable "tls_private_key" {
  description = "Content of the TLS private key"
}
