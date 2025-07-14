# Встановлення плагіну CSI Driver для EBS
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"
  resolve_conflicts = "OVERWRITE" # Важливо для автоматичного встановлення

  depends_on = [
    aws_eks_cluster.main,
    kubernetes_config_map.aws_auth # Залежить від коректної авторизації вузлів
  ]
}