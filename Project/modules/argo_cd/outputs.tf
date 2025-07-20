# Progect/modules/argo_cd/outputs.tf
# Виводи модуля Argo CD Helm.

# Вивід URL Argo CD сервера
output "argocd_server_url" {
  description = "URL для доступу до веб-інтерфейсу Argo CD."
  # Припускаємо, що сервіс Argo CD встановлено як LoadBalancer.
  # Якщо використовується NodePort або Ingress, логіка виводу URL буде іншою.
  # Для NodePort: "http://<IP_ноди>:${data.kubernetes_service.argocd_server.spec[0].port[0].node_port}"
  # Для Ingress: "http://<адреса_Ingress>"
  value = "http://${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname}"
}

# Отримання даних про сервіс Argo CD сервера
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "${var.release_name}-argocd-server" # Стандартна назва сервісу Argo CD сервера
    namespace = var.namespace
  }
}

# Вивід початкового пароля адміністратора Argo CD
output "argocd_initial_admin_password" {
  description = "Початковий пароль адміністратора Argo CD. Використовуйте 'admin' як ім'я користувача."
  # Пароль зазвичай зберігається в секреті argocd-initial-admin-secret
  value       = base64decode(data.kubernetes_secret.argocd_initial_admin_secret.data["password"])
  sensitive   = true # Позначаємо як чутливу змінну
}

# Отримання даних про секрет Argo CD з початковим паролем адміністратора
data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret" # Стандартна назва секрету з початковим паролем
    namespace = var.namespace
  }
}
