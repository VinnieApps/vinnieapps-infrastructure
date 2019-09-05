provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

data "google_client_config" "current" {
  // Empty block
}

provider "kubernetes" {
  host                   = module.primary_gke.endpoint

  cluster_ca_certificate = base64decode(module.primary_gke.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

module "buckets" {
  source = "../modules/buckets"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}

module "primary_gke" {
  source = "../modules/gke_cluster"

  environment = var.environment
  zone        = var.zone
}

module "mysql_database" {
  source = "../modules/mysql_instance"

  db_name     = var.db_name
  db_password = var.db_password
  environment = var.environment
}

data "google_dns_managed_zone" "base_domain" {
  name = var.base_domain_zone_name
}

module "photos_application" {
  source = "../modules/photos_webapp"

  domain          = "photos-${var.environment}.${data.google_dns_managed_zone.base_domain.dns_name}"
  environment     = var.environment
  tls_certificate = file(var.tls_certificate_file)
  tls_private_key = file(var.tls_private_key)
}

resource "google_dns_record_set" "environment_domain" {
  name = "photos-${var.environment}.${data.google_dns_managed_zone.base_domain.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${data.google_dns_managed_zone.base_domain.name}"

  rrdatas = [ module.photos_application.load_balancer_ip_address ]
}
