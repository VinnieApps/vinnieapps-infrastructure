module "primary_gke" {
  source = "../../../terraform/shared/gke_cluster"

  environment = var.environment
  zone        = var.zone
}