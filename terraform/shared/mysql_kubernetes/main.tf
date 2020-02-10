resource "random_password" "mysql" {
  length  = 50
  special = false
}

locals {
  mysql_version = 8

  username = "root"
}

resource "kubernetes_secret" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }

  data = {
    username = local.username
    password = random_password.mysql.result
  }
}

resource "kubernetes_config_map" "mysql" {
  metadata {
    name      = "${var.db_name}-mysql"
    namespace = var.namespace
  }

  data = {
    "primary.cnf" = <<PRIMARY
[mysqld]
log-bin
PRIMARY

    "secondary.cnf" = <<SECONDARY
[mysqld]
super-read-only
SECONDARY
  }
}

resource "kubernetes_config_map" "mysql-scripts" {
  metadata {
    name      = "${var.db_name}-mysql-scripts"
    namespace = var.namespace
  }

  data = {
    "ping.sh" = <<SCRIPT
#!/bin/bash
mysql -u root -p$MYSQL_ROOT_PASSWORD -h localhost -e 'SELECT 1'
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
      name : "${var.db_name}-mysql"
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
      name : "${var.db_name}-mysql"
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
    replicas     = var.node_count
    /* TODO - Replication is not working correctly
     * - Starting more than one container, the second one doesn't get the root password correctly
     *   which means readiness probe never passes.
     */

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
        init_container {
          name  = "init-mysql"
          image = "mysql:${local.mysql_version}"
          command = [
            "bash",
            "-c",
            <<SCRIPT
              set -ex
              [[ `hostname` =~ -([0-9]+)$ ]] || exit 1
              ordinal=$${BASH_REMATCH[1]}
              echo [mysqld] > /mnt/conf.d/server-id.cnf
              echo server-id=$((100 + $ordinal)) >> /mnt/conf.d/server-id.cnf
              if [[ $ordinal -eq 0 ]]; then
                cp /mnt/config-map/primary.cnf /mnt/conf.d/
              else
                cp /mnt/config-map/secondary.cnf /mnt/conf.d/
              fi
            SCRIPT
          ]

          volume_mount {
            name       = "config-map"
            mount_path = "/mnt/config-map"
          }

          volume_mount {
            name       = "conf"
            mount_path = "/mnt/conf.d"
          }
        }

        container {
          name  = "mysql"
          image = "mysql:${local.mysql_version}"

          env {
            name = "MYSQL_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "password"
              }
            }
          }

          /* NOTE, for history
           * - MYSQL_PWD, container works first run, then crashes and restarts with no password setup
           * - Trying to use MYSQL_USER/MYSQL_PASSWORD causes error: Operation CREATE USER failed for 'root'@'%'
           *   container crashes and restarts, password works for root but not for MYSQL_USER
           * - Both cases I see the message:  [Server] root@localhost is created with an empty password
           */

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
              command = ["mysqladmin", "ping"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = ["/bin/bash", "/opt/scripts/ping.sh"]
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
