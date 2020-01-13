variable "ip_address" {
  description = "IP address to associate the subdomain with"
}

variable "managed_zone_name" {
  description = "Name of the Manage Zone in Cloud DNS"
}

variable "subdomain_fqdn" {
  description = "Domain name where the application will be exposed"
}
