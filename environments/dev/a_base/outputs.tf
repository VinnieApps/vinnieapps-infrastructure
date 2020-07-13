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
