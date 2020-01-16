locals {
  frontend_name = "photos-frontend"
  frontend_port = 80

  service_name = "photos-service"
  service_port = 8080
}

resource "kubernetes_namespace" "photos" {
  metadata {
    annotations = {
      name = "photos"
    }

    labels = {
      istio-injection = "enabled"
    }

    name = "photos"
  }
}

resource "kubernetes_secret" "tls_certificate" {
  metadata {
    name = "istio-ingressgateway-certs"
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
  }

  spec {
    type = "ClusterIP"

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
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = local.service_name
    }

    port {
      port        = local.service_port
      target_port = local.service_port
    }
  }
}
