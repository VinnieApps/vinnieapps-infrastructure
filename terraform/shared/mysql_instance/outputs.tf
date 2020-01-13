output "ip_address" {
  description = "IP address of the created instance"
  value = google_compute_instance.mysql_instance.network_interface.0.access_config.0.nat_ip
}
