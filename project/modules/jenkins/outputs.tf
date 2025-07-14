output "jenkins_url" {
  description = "URL of the Jenkins Load Balancer."
  value       = join("", ["http://", kubernetes_service.jenkins_master.status[0].load_balancer[0].ingress[0].hostname])
}

# Отримання початкового пароля Jenkins (може зайняти час, якщо Jenkins не готовий)
resource "null_resource" "get_jenkins_admin_password" {
  depends_on = [helm_release.jenkins]

  provisioner "local-exec" {
    command = <<EOT
      while true; do
        JENKINS_POD=$(kubectl get pods -n jenkins -l app.kubernetes.io/component=jenkins-master -o jsonpath='{.items[0].metadata.name}' --field-selector=status.phase=Running)
        if [ -n "$JENKINS_POD" ]; then
          JENKINS_PASSWORD=$(kubectl exec -n jenkins "$JENKINS_POD" -- cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null)
          if [ -n "$JENKINS_PASSWORD" ]; then
            echo "$JENKINS_PASSWORD" > jenkins_initial_admin_password.txt
            break
          fi
        fi
        echo "Waiting for Jenkins pod to be ready and password to be available..."
        sleep 10
      done
    EOT
    working_dir = path.module
  }
}

output "jenkins_admin_password" {
  description = "Initial Admin Password for Jenkins (stored in jenkins_initial_admin_password.txt in module dir)"
  value       = file("${path.module}/jenkins_initial_admin_password.txt")
  sensitive   = true
}

# Kubernetes service for Jenkins master (для отримання hostname)
data "kubernetes_service" "jenkins_master" {
  metadata {
    name      = "jenkins"
    namespace = "jenkins"
  }
}