# Datasource: Get the default EBS CSI addon version compatible with EKS version
data "aws_eks_addon_version" "ebs_csi_default" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.cluster_version
}

# Datasource: Get the latest available EBS CSI addon version
data "aws_eks_addon_version" "ebs_csi_latest" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = var.cluster_version
  most_recent        = true
}

# Resource: Install EBS CSI Driver addon
resource "aws_eks_addon" "ebs_csi" {
  depends_on = [
    aws_iam_role.ebs_csi_iam_role,
    aws_eks_pod_identity_association.ebs_csi,
    aws_eks_addon.pia,
    aws_eks_node_group.gp-eks-node-group
  ]
  cluster_name                = aws_eks_cluster.gp-eks-cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = data.aws_eks_addon_version.ebs_csi_latest.version

  service_account_role_arn    = aws_iam_role.ebs_csi_iam_role.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name        = "${aws_eks_cluster.gp-eks-cluster.name}-aws-ebs-csi-addon"
    Environment = var.env
    Component   = "Amazon EBS CSI Driver"
  }
}