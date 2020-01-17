output "external_ip_address" {
  description = "IP address of the external load balancer for the nginx-ingress."
  value       = kubernetes_service.nginx_ingress.load_balancer_ingress[0].ip
}