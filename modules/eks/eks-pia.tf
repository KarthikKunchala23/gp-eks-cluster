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
    depends_on = [aws_eks_node_group.gp-eks-node-group]
    cluster_name = aws_eks_cluster.gp-eks-cluster.name
    addon_name = "eks-pod-identity-agent"
    addon_version = data.aws_eks_addon_version.pia-latest.version
    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
}


## EKS Pod identity Association for Load Balancer Controller
resource "aws_eks_pod_identity_association" "lbc-pia-association" {
    cluster_name = aws_eks_cluster.gp-eks-cluster.name
    namespace = "kube-system"
    service_account = "aws-load-balancer-controller"
    role_arn = aws_iam_role.lbc-role.arn
}

## EKS Pod identity Association for EBS CSI Driver
resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.gp-eks-cluster.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_iam_role.arn
}