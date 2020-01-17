locals {
  namespace = "ingress-nginx"

  common_labels = {
    "app.kubernetes.io/name"    = "ingress-nginx"
    "app.kubernetes.io/part-of" = "ingress-nginx"
  }
}

resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = local.namespace
    labels = local.common_labels
  }
}

resource "kubernetes_config_map" "nginx_configuration" {
  metadata {
    name = "nginx-configuration"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
}

resource "kubernetes_config_map" "tcp_services" {
  metadata {
    name = "tcp-services"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
}

resource "kubernetes_config_map" "udp_services" {
  metadata {
    name = "udp-services"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
}

resource "kubernetes_service_account" "nginx_ingress" {
  metadata {
    name = "nginx-ingress-serviceaccount"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
}

resource "kubernetes_cluster_role" "nginx_ingress" {
  metadata {
    name = "nginx-ingress-clusterrole"
    labels = local.common_labels
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "endpoints", "nodes", "pods", "secrets"]
    verbs      = ["list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses/status"]
    verbs      = ["update"]
  }
}

resource "kubernetes_role" "nginx_ingress" {
  metadata {
    name = "nginx-ingress-role"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps", "pods", "secrets", "namespaces"]
    verbs          = ["get"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["ingress-controller-leader-nginx"]
    verbs          = ["get", "update"]
  }
  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    verbs          = ["create"]
  }
  rule {
    api_groups     = [""]
    resources      = ["endpoints"]
    verbs          = ["get"]
  }
}

resource "kubernetes_role_binding" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress-role-nisa-binding"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.nginx_ingress.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx_ingress.metadata[0].name
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
  }
}

resource "kubernetes_cluster_role_binding" "nginx_ingress" {
  metadata {
    name = "nginx-ingress-clusterrole-nisa-binding"
    labels = local.common_labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.nginx_ingress.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.nginx_ingress.metadata[0].name
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
  }
}

resource "kubernetes_deployment" "nginx_ingress" {
  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  metadata {
    name = "nginx-ingress-controller"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }

  spec {
    replicas = 1
    selector {
      match_labels = local.common_labels
    }

    template {
      metadata {
        annotations = {
          "prometheus.io/port" = "10254"
          "prometheus.io/scrape" = "true"
        }
        labels = local.common_labels
      }

      spec {
        automount_service_account_token = true
        container {
          name  = "nginx-ingress-controller"
          image = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:master"
          args = [
            "/nginx-ingress-controller",
            "--configmap=$(POD_NAMESPACE)/nginx-configuration",
            "--tcp-services-configmap=$(POD_NAMESPACE)/tcp-services",
            "--udp-services-configmap=$(POD_NAMESPACE)/udp-services",
            "--publish-service=$(POD_NAMESPACE)/ingress-nginx",
            "--annotations-prefix=nginx.ingress.kubernetes.io"
          ]
          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          lifecycle {
            pre_stop {
              exec {
                command = ["/wait-shutdown"]
              }
            }
          }
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 10
          }
          port {
            name = "http"
            container_port = 80
            protocol = "TCP"
          }
          port {
            name = "https"
            container_port = 443
            protocol = "TCP"
          }
          readiness_probe {
            http_get {
              path = "/healthz"
              port = 10254
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 10
          }
          security_context {
            allow_privilege_escalation = true
            capabilities {
              drop = ["ALL"]
              add = ["NET_BIND_SERVICE"]
            }
            run_as_user = 101
          }
        }

        service_account_name             = kubernetes_service_account.nginx_ingress.metadata[0].name
        termination_grace_period_seconds = 300
      }
    }
  }
}

resource "kubernetes_limit_range" "nginx_ingress" {
  metadata {
    name = "ingress-nginx"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
  spec {
    limit {
      type = "Container"
      default = {
        cpu    = "100m"
        memory = "90Mi"
      }
      max = {
        cpu    = "100m"
        memory = "90Mi"
      }
    }
  }
}

resource "kubernetes_service" "nginx_ingress" {
  metadata {
    name = "ingress-nginx"
    namespace = kubernetes_namespace.nginx_ingress.metadata[0].name
    labels = local.common_labels
  }
  spec {
    external_traffic_policy = "Local"
    selector = local.common_labels
    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "http"
    }
    port {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "https"
    }

    type = "LoadBalancer"
  }
}
