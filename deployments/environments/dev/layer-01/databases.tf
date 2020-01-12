module "photos_mysql" {
  source = "../../../shared/mysql_instance"

  db_name     = "photos"
  db_password = var.db_password
  environment = var.environment
  region      = var.region
  zone        = var.zone
}
