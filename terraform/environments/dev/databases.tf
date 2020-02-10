module "photos_mysql" {
  source = "../../shared/mysql_kubernetes"

  db_name     = "photos"
  db_password = var.db_password
  node_count  = 1
  namespace   = "photos"
}
