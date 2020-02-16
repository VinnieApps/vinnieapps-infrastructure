resource "random_password" "mysql_root" {
  length  = 50
  special = false
}

resource "random_password" "mysql_username" {
  length  = 25
  special = false
}

resource "random_password" "mysql_password" {
  length  = 50
  special = false
}

locals {
  mysql_version = 8
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }

  data = {
    username      = random_password.mysql_username.result
    password      = random_password.mysql_password.result
    root_password = random_password.mysql_root.result
  }
}

resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }
}

resource "kubernetes_config_map" "mysql-scripts" {
  metadata {
    name      = "${var.db_name}-mysql-scripts"
    namespace = var.namespace
  }

  data = {
    "is_ready.sh" = <<SCRIPT
#!/bin/bash
mysql -u root -p$MYSQL_ROOT_PASSWORD -h localhost -e 'SELECT 1'
SCRIPT

    "ping.sh" = <<SCRIPT
#!/bin/bash
mysqladmin -p$MYSQL_ROOT_PASSWORD ping
SCRIPT
  }
}

resource "kubernetes_service" "mysql_primary" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }
  spec {
    cluster_ip = "None"
    port {
      name = "mysql"
      port = 3306
    }
    selector = {
      app: "${var.db_name}-mysql"
    }
  }
}

resource "kubernetes_service" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql-read"
    namespace = var.namespace
  }
  spec {
    port {
      name = "mysql"
      port = 3306
    }
    selector = {
      app: "${var.db_name}-mysql"
    }
  }
}

resource "kubernetes_stateful_set" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }
  spec {
    service_name = "${var.db_name}-mysql"
    replicas     = 1 // TODO - Fix this to support real-time following secondaries

    selector {
      match_labels = {
        app = "${var.db_name}-mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.db_name}-mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:${local.mysql_version}"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "root_password"
              }
            }
          }

          env {
            name = "MYSQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "password"
              }
            }
          }

          env {
            name = "MYSQL_USER"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name  = "MYSQL_DATABASE"
            value = var.db_name
          }

          port {
            name           = "mysql"
            container_port = 3306
          }

          volume_mount {
            name       = "${var.db_name}-mysql-data"
            mount_path = "/var/lib/mysql"
            sub_path   = "mysql"
          }

          volume_mount {
            name       = "conf"
            mount_path = "/etc/mysql/conf.d"
          }

          volume_mount {
            name       = "scripts"
            mount_path = "/opt/scripts"
          }

          liveness_probe {
            exec {
              command = ["/bin/bash", "/opt/scripts/ping.sh"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = ["/bin/bash", "/opt/scripts/is_ready.sh"]
            }
            initial_delay_seconds = 5
            period_seconds        = 2
            timeout_seconds       = 1
          }
        }

        volume {
          name = "conf"
          empty_dir {}
        }

        volume {
          name = "config-map"
          config_map {
            name = kubernetes_config_map.mysql.metadata[0].name
          }
        }

        volume {
          name = "scripts"
          config_map {
            default_mode = "0777"
            name         = kubernetes_config_map.mysql-scripts.metadata[0].name
          }
        }
      }
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 0
      }
    }

    volume_claim_template {
      metadata {
        name = "${var.db_name}-mysql-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = var.volume_size
          }
        }
      }
    }
  }
}
