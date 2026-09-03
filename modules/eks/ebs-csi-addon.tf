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
  count                     = var.enable_aws_ebs_csi_driver ? 1 : 0
  depends_on = [
    aws_eks_pod_identity_association.pia-association,
    aws_eks_addon.pia,
    aws_eks_node_group.gp-eks-node-group
  ]
  cluster_name                = aws_eks_cluster.gp-eks-cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = data.aws_eks_addon_version.ebs_csi_latest.version

  service_account_role_arn    = var.ebs_csi_driver_role_arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name        = "${aws_eks_cluster.gp-eks-cluster.name}-aws-ebs-csi-addon"
    Environment = var.env
    Component   = "Amazon EBS CSI Driver"
  }
}