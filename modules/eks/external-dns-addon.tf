data "aws_eks_addon_version" "externaldns_latest" {
  addon_name         = "external-dns"
  kubernetes_version = aws_eks_cluster.gp-eks-cluster.version
  most_recent        = true
}


resource "aws_eks_addon" "externaldns" {
  depends_on = [
    aws_iam_role.externaldns_role,
    aws_eks_pod_identity_association.externaldns,
    aws_eks_addon.pia,
    aws_eks_node_group.gp-eks-node-group
  ]  
  cluster_name                = aws_eks_cluster.gp-eks-cluster.name
  addon_name                  = "external-dns"
  addon_version               = data.aws_eks_addon_version.externaldns_latest.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  service_account_role_arn = aws_iam_role.externaldns_role.arn

  tags = {
    Component   = "ExternalDNS"
    ManagedBy   = "Terraform"
  }
}