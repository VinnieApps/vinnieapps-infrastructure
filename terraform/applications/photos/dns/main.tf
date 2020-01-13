resource "google_dns_record_set" "environment_domain" {
  name = var.subdomain_fqdn
  type = "A"
  ttl  = 300

  managed_zone = var.managed_zone_name

  rrdatas = [ var.ip_address ]
}
