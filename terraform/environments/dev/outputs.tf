output "main_server_name" {
  description = "Name of the main server"
  value       = google_compute_instance.dev_main.name
}

output "mysql_username" {
  description = "Username for the MySQL database"
  sensitive   = true
  value       = random_password.mysql_username.result
}

output "mysql_password" {
  description = "Password for the MySQL database"
  sensitive   = true
  value       = random_password.mysql_password.result
}

output "mysql_root_password" {
  description = "Root password for the MySQL database"
  sensitive   = true
  value       = random_password.mysql_root.result
}

output "server_key" {
  description = "Key used to sign session objects in Flask"
  sensitive   = true
  value       = random_password.server_key.result
}
