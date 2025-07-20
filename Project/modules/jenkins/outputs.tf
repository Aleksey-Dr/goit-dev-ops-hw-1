# Progect/modules/jenkins/outputs.tf
# Виводи модуля Jenkins Helm.

# Вивід URL Jenkins
output "jenkins_url" {
  description = "URL для доступу до Jenkins."
  value = "http://${data.kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].hostname}:8080" # Припускаємо LoadBalancer
  # Примітка: Якщо використовується NodePort або Ingress, логіка виводу URL буде іншою.
  # Для NodePort: "http://<IP_ноди>:${data.kubernetes_service.jenkins.spec[0].port[0].node_port}"
  # Для Ingress: "http://<адреса_Ingress>"
}

# Отримання даних про сервіс Jenkins
data "kubernetes_service" "jenkins" {
  metadata {
    name      = var.release_name
    namespace = var.namespace
  }
}

# Вивід початкового пароля адміністратора Jenkins
output "jenkins_admin_password" {
  description = "Початковий пароль адміністратора Jenkins."
  value       = base64decode(data.kubernetes_secret.jenkins_admin_secret.data["jenkins-admin-password"])
  sensitive   = true # Позначаємо як чутливу змінну
}

# Отримання даних про секрет Jenkins з паролем адміністратора
data "kubernetes_secret" "jenkins_admin_secret" {
  metadata {
    name      = "${var.release_name}-jenkins" # Зазвичай секрет називається <release_name>-jenkins
    namespace = var.namespace
  }
}
