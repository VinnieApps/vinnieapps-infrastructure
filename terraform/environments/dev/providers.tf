provider "google" {
  credentials = "../../../credentials.json"
  project     = var.project_id
  region      = var.region
  version     = "~> 3.4"
  zone        = var.zone
}
