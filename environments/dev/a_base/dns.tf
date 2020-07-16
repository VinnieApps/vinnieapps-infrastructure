data "google_dns_managed_zone" "base_domain" {
  name = var.base_domain_zone_name
}

locals {
  fqdn   = data.google_dns_managed_zone.base_domain.dns_name
  domain = substr(local.fqdn, 0, length(local.fqdn) - 1)

  my_finances_subdomain_fqdn = "finances-dev.${local.fqdn}"
  my_finances_subdomain      = "finances-dev.${local.domain}"

  photos_subdomain_fqdn = "photo-dev.${local.fqdn}"
  photos_subdomain      = "photo-dev.${local.domain}"
}

resource "google_dns_record_set" "my_finances_domain" {
  name = local.my_finances_subdomain_fqdn
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.base_domain.name

  rrdatas = [ google_compute_instance.dev_main.network_interface.0.access_config.0.nat_ip ]
}

resource "google_dns_record_set" "photos_domain" {
  name = local.photos_subdomain_fqdn
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.base_domain.name

  rrdatas = [ google_compute_instance.dev_main.network_interface.0.access_config.0.nat_ip ]
}
