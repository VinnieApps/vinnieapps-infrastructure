module "primary_gke" {
  source = "../../modules/gke_cluster"

  environment = var.environment
  zone        = var.zone
}