resource "aws_eks_access_entry" "karpenter_node_access" {
  depends_on = [module.eks]
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.karpenter_node.arn
  type          = "EC2_LINUX"
}