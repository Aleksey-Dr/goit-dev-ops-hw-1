resource "helm_release" "argo_cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "5.45.0" # Перевірте актуальну версію чарту
  values     = [file("${path.module}/values.yaml")]
}