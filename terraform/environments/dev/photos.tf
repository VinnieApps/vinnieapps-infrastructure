data "google_dns_managed_zone" "base_domain" {
  name = var.base_domain_zone_name
}

locals {
  fqdn      = data.google_dns_managed_zone.base_domain.dns_name
  domain    = substr(local.fqdn, 0, length(local.fqdn) - 1)

  subdomain      = "photos%{ if var.environment != "prod" }-${var.environment}%{ endif }.${local.domain}"
  subdomain_fqdn = "photos%{ if var.environment != "prod" }-${var.environment}%{ endif }.${local.fqdn}"
}

module "photos_storage" {
  source = "../../applications/photos/storage"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}

module "photos_kubernetes_services" {
  source = "../../applications/photos/kubernetes"

  environment     = var.environment
  subdomain       = local.subdomain
  tls_certificate = file("../../cert.pem")
  tls_private_key = file("../../privkey.pem")
}

module "photos_subdomain_dns_record" {
  source = "../../applications/photos/dns"

  ip_address        = module.nginx_ingress_controller.external_ip_address
  managed_zone_name = data.google_dns_managed_zone.base_domain.name
  subdomain_fqdn    = local.subdomain_fqdn
}

module "photos_configuration" {
  source = "../../applications/photos/configuration"

  db_host              = module.photos_mysql.ip_address
  db_name              = "photos"
  db_password          = var.db_password
  db_username          = "appuser"
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
  subdomain            = local.subdomain
}