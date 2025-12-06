# Removed outputs that referenced the non-existent AWS LB
# You can keep other outputs here if needed

# Example placeholder outputs (optional)
output "nginx_ingress_status" {
  value = "NGINX Ingress is deployed via Helm; check using kubectl"
}

output "note" {
  value = "Use 'kubectl get svc -n ingress-nginx' to find the LoadBalancer DNS/IP"
}
