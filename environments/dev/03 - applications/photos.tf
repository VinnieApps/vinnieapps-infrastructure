data "google_dns_managed_zone" "base_domain" {
  name = var.base_domain_zone_name
}

locals {
  fqdn   = data.google_dns_managed_zone.base_domain.dns_name
  domain = substr(local.fqdn, 0, length(local.fqdn) - 1)

  subdomain      = "photos%{if var.environment != "prod"}-${var.environment}%{endif}.${local.domain}"
  subdomain_fqdn = "photos%{if var.environment != "prod"}-${var.environment}%{endif}.${local.fqdn}"
}

module "photos_mysql" {
  source = "../../../terraform/shared/mysql_kubernetes"

  db_name     = "photos"
  node_count  = 1
  namespace   = "photos"
}

module "photos_storage" {
  source = "../../../terraform/applications/photos/storage"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}

module "photos_kubernetes" {
  source = "../../../terraform/applications/photos/kubernetes"

  environment     = var.environment
  subdomain       = local.subdomain
  tls_certificate = file("../cert.pem")
  tls_private_key = file("../privkey.pem")
}

data "kubernetes_service" "envoy" {
  metadata {
    name      = "envoy"
    namespace = "projectcontour"
  }
}

module "photos_subdomain_dns_record" {
  source = "../../../terraform/applications/photos/dns"

  ip_address        = data.kubernetes_service.envoy.load_balancer_ingress.0.ip
  managed_zone_name = data.google_dns_managed_zone.base_domain.name
  subdomain_fqdn    = local.subdomain_fqdn
}

module "photos_configuration" {
  source     = "../../../terraform/applications/photos/configuration"

  credentials_json_content = file("../credentials.json")
  db_host                  = "photos-mysql-0.photos-mysql.photos" // For stateful sets, $POD_NAME.$STATE_FULSET_NAME.$NAMESPACE
  db_name                  = "photos"
  db_password              = module.photos_mysql.password
  db_username              = module.photos_mysql.username
  environment              = var.environment
  google_client_id         = var.google_client_id
  google_client_secret     = var.google_client_secret
  namespace                = module.photos_kubernetes.namespace
  subdomain                = local.subdomain
}
