output "photos_bucket_name" {
  value = google_storage_bucket.image_store.name
}

output "thumbnails_bucket_name" {
  value = google_storage_bucket.thumbnail_store.name
}
