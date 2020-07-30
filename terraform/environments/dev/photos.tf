module "photos_storage" {
  source = "../../applications/photos/storage"

  environment = var.environment
  region      = var.region
  zone        = var.zone
}