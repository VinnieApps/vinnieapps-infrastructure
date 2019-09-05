provider "google" {
  credentials = file("credentials.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

module "base_photos" {
  source = "../base/photos"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}
