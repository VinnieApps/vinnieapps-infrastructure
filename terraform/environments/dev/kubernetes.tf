module "primary_gke" {
  source = "../../shared/gke_cluster"

  environment = var.environment
  zone        = var.zone
}