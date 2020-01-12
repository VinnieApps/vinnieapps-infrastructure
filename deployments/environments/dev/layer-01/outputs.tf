output "photos_database_password" {
  description = "Password used for root and appuser."
  value       = var.db_password
}

output "photos_database_ip" {
  description = "IP address of the compute instance where photos DB is running."
  value       = module.photos_mysql.ip_address
}
