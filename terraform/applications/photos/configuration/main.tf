resource "random_password" "jwt_secret" {
  length = 256
  special = false
}

data "template_file" "configuration_file" {
  template = file("${path.module}/application.yml")
  vars = {
    credentials_content  = replace(var.credentials_json_content, "\n", "")
    db_host              = var.db_host
    db_name              = var.db_name
    db_password          = var.db_password
    db_username          = var.db_username
    environment          = var.environment
    google_client_id     = var.google_client_id
    google_client_secret = var.google_client_secret
    jwt_secret           = random_password.jwt_secret.result
    subdomain            = var.subdomain
  }
}

resource "kubernetes_secret" "photos-service" {
  metadata {
    name      = "photos-service"
    namespace = "photos"
  }

  data = {
    "application.yml"  = data.template_file.configuration_file.rendered
  }

  type = "Opaque"
}