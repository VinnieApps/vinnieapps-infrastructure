provider "google" {
  credentials = file("../../credentials.json")
  project     = var.project_id
  region      = var.region
  version     = "~> 3.4"
  zone        = var.zone
}

data "google_client_config" "current" {
  // Empty block
}

provider "kubernetes" {
  host                   = module.primary_gke.endpoint

  cluster_ca_certificate = base64decode(module.primary_gke.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  version                = "~> 1.10"
}

provider "random" {
  version = "~> 2.2"
}

provider "template" {
  version = "~> 2.1"
}