data "aws_iam_policy_document" "karpenter_controller_assume" {
  statement {
    sid = "PodIdentity"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "karpenter_ec2_read" {
  name = "karpenter_ec2_read_policy_dev_platform"
}

data "aws_iam_policy" "karpenter_ec2_controller" {
  name = "karpenter_ec2_controller_policy_dev_platform"
}

data "aws_iam_policy" "karpenter_iam_controller" {
  name = "karpenter_iam_controller_policy_dev_platform"
}

resource "aws_iam_role" "karpenter_controller" {
  name               = "${module.eks.cluster_name}-karpenter-controller-role"
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "karpenter_policy_attachment_ec2_read" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = data.aws_iam_policy.karpenter_ec2_read.arn
}

resource "aws_iam_role_policy_attachment" "karpenter_policy_attachment_ec2_controller" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = data.aws_iam_policy.karpenter_ec2_controller.arn
}

resource "aws_iam_role_policy_attachment" "karpenter_policy_attachment_iam_controller" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = data.aws_iam_policy.karpenter_iam_controller.arn
}