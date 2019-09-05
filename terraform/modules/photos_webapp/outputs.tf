output "load_balancer_ip_address" {
  value = kubernetes_ingress.photos_ingress.load_balancer_ingress[0].ip
}
