resource "google_storage_bucket" "image_store" {
  name     = "photos-vinnieapps-${var.environment}"
  location = var.region
  force_destroy = true

  labels = {
    environment = var.environment
  }

  storage_class = "REGIONAL"
}

resource "google_storage_bucket" "thumbnail_store" {
  name     = "photos-vinnieapps-${var.environment}-thumbnails"
  location = var.region
  force_destroy = true

  labels = {
    environment = var.environment
  }

  storage_class = "REGIONAL"
}
