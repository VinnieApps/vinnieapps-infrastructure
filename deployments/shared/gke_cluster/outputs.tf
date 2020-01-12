output "cluster_ca_certificate" {
  description = "Certificate Authority certificate for the cluster"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "endpoint" {
  description = "Endpoint where to access the cluster"
  value       = google_container_cluster.primary.endpoint
}
