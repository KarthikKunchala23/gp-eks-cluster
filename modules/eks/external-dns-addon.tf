data "aws_eks_addon_version" "externaldns_latest" {
  addon_name         = "external-dns"
  kubernetes_version = aws_eks_cluster.gp-eks-cluster.version
  most_recent        = true
}


resource "aws_eks_addon" "externaldns" {
  count                     = var.enable_external_dns ? 1 : 0
  depends_on = [
    aws_eks_pod_identity_association.pia-association,
    aws_eks_addon.pia,
    aws_eks_node_group.gp-eks-node-group
  ]  
  cluster_name                = aws_eks_cluster.gp-eks-cluster.name
  addon_name                  = "external-dns"
  addon_version               = data.aws_eks_addon_version.externaldns_latest.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  # service_account_role_arn = var.external_dns_service_account_role_arn

  configuration_values = jsonencode({
    policy = "sync"
    registry = "txt"
    txtOwnerId = aws_eks_cluster.gp-eks-cluster.name
    domainFilters = ["cloudlearningtraining.com "]
  })

  tags = {
    Component   = "ExternalDNS"
    ManagedBy   = "Terraform"
  }
}