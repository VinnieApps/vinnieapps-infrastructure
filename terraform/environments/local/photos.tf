module "photos_storage" {
  source = "../../../terraform/applications/photos/storage"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}