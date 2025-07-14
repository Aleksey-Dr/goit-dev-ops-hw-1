resource "kubernetes_manifest" "django_app_argocd_application" {
  depends_on = [helm_release.argo_cd]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "django-app"
      namespace = "argocd"
      finalizers = [
        "resources-finalizer.argocd.argoproj.io"
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.helm_charts_repo_url
        targetRevision = "HEAD"
        path           = "charts/django-app" # Шлях до Helm-чарту Django-додатка в репозиторії
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default" # Простір імен, куди розгортати Django-додаток
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}