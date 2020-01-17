output "photos_database_password" {
  description = "Password used for root and appuser."
  value       = var.db_password
}

output "photos_database_ip" {
  description = "IP address of the compute instance where photos DB is running."
  value       = module.photos_mysql.ip_address
}

output "external_ip_address" {
  description = "IP address to access this environment."
  value       = module.nginx_ingress_controller.external_ip_address
}
