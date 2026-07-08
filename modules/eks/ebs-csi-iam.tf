# Resource: Create IAM Role for EBS CSI Driver
resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "${aws_eks_cluster.gp-eks-cluster.name}-ebs-csi-iam-role"
  assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json

  tags = {
    Name        = "${aws_eks_cluster.gp-eks-cluster.name}-ebs-csi-iam-role"
    Environment = var.env
    Component   = "Amazon EBS CSI Driver"
  }
}

# Resource: Attach AWS Managed Policy for EBS CSI Driver
resource "aws_iam_role_policy_attachment" "ebs_csi_managed_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_iam_role.name
}