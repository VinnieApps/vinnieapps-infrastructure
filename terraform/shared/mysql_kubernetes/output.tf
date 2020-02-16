output "password" {
  description = "Password used for the database."
  value       = random_password.mysql_password.result
}

output "username" {
  description = "Username used to access the database."
  value       = random_password.mysql_username.result
}

