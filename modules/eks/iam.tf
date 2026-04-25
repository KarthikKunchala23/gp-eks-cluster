resource "aws_iam_role" "gp-eks-cluster-role" {
  name = "${var.cluster_name}-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

resource "aws_iam_role_policy_attachment" "gp-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.gp-eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "gp-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.gp-eks-cluster-role.name
}