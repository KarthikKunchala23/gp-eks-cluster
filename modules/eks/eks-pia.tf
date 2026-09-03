data "aws_eks_addon_version" "pia-default" {
    addon_name = "eks-pod-identity-agent"
    kubernetes_version = aws_eks_cluster.gp-eks-cluster.version
}

data "aws_eks_addon_version" "pia-latest" {
    addon_name = "eks-pod-identity-agent"
    kubernetes_version = aws_eks_cluster.gp-eks-cluster.version
    most_recent = true
}

## EKS Pod Identity Agent Addon
resource "aws_eks_addon" "pia" {
    count = var.enable_aws_pia ? 1 : 0
    depends_on = [aws_eks_node_group.gp-eks-node-group]
    cluster_name = aws_eks_cluster.gp-eks-cluster.name
    addon_name = "eks-pod-identity-agent"
    addon_version = data.aws_eks_addon_version.pia-latest.version
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
}


## EKS Pod identity Association
resource "aws_eks_pod_identity_association" "pia-association" {
    for_each = var.enable_aws_pia ? var.pod_identities : {}
    depends_on = [aws_eks_addon.pia]
    cluster_name = aws_eks_cluster.gp-eks-cluster.name
    namespace = each.value.namespace
    service_account = each.value.service_account
    role_arn = each.value.role_arn
}