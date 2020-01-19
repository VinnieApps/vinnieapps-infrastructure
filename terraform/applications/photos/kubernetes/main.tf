locals {
  frontend_name = "photos-frontend"
  frontend_port = 80

  service_name = "photos-service"
  service_port = 8080

  namespace = "photos"
}

resource "kubernetes_namespace" "photos" {
  metadata {
    name = local.namespace
  }
}

resource "kubernetes_secret" "tls_certificate" {
  metadata {
    name = "photos-tls"
    namespace = local.namespace
  }

  data = {
    "tls.crt" = var.tls_certificate
    "tls.key" = var.tls_private_key
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_service" "photos_frontend" {
  metadata {
    name = local.frontend_name
    namespace = local.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = local.frontend_name
    }

    port {
      port        = local.frontend_port
      target_port = local.frontend_port
    }
  }
}

resource "kubernetes_service" "photos_service" {
  metadata {
    name = local.service_name
    namespace = local.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = local.service_name
    }

    port {
      port        = local.service_port
      target_port = local.service_port
    }
  }
}

resource "kubernetes_ingress" "photos_ingress" {
  metadata {
    name = "photos-ingress"
    namespace = local.namespace

    labels = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    tls {
      hosts = [var.subdomain]
      secret_name = kubernetes_secret.tls_certificate.metadata[0].name
    }

    rule {
      host = var.subdomain
      http {
        path {
          path = "/"
          backend {
            service_name = local.frontend_name
            service_port = local.frontend_port
          }
        }

        path {
          path = "/authenticate"
          backend {
            service_name = local.service_name
            service_port = local.service_port
          }
        }

        path {
          path = "/api/v1"
          backend {
            service_name = local.service_name
            service_port = local.service_port
          }
        }
      }
    }
  }
}
