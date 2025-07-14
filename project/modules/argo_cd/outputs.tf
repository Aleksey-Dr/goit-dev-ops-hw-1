output "argo_cd_url" {
  description = "URL of the Argo CD Load Balancer."
  value       = join("", ["https://", kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname])
}

resource "null_resource" "get_argo_cd_initial_password" {
  depends_on = [helm_release.argo_cd]

  provisioner "local-exec" {
    command = <<EOT
      while true; do
        ARGOCD_POD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}' --field-selector=status.phase=Running)
        if [ -n "$ARGOCD_POD" ]; then
          ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
          if [ -n "$ARGOCD_PASSWORD" ]; then
            echo "$ARGOCD_PASSWORD" > argo_cd_initial_admin_password.txt
            break
          fi
        fi
        echo "Waiting for Argo CD pod to be ready and password to be available..."
        sleep 10
      done
    EOT
    working_dir = path.module
  }
}

output "argo_cd_initial_password" {
  description = "Initial Admin Password for Argo CD (stored in argo_cd_initial_admin_password.txt in module dir)"
  value       = file("${path.module}/argo_cd_initial_admin_password.txt")
  sensitive   = true
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}