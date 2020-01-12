module "photos_storage" {
  source = "../../modules/applications/photos/storage"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}