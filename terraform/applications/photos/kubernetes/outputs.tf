output "namespace" {
  description = "Kubernetes namespace for the photos application."
  value       = kubernetes_namespace.photos.metadata[0].name
}
