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

resource "aws_iam_role_policy_attachment" "gp_cluster_AmazonEKSComputePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
  role       = aws_iam_role.gp-eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "gp_cluster_AmazonEKSBlockStoragePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
  role       = aws_iam_role.gp-eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "gp_cluster_AmazonEKSLoadBalancingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
  role       = aws_iam_role.gp-eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "gp_cluster_AmazonEKSNetworkingPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  role       = aws_iam_role.gp-eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "gp_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.gp-eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

## EKS Node Group Role
resource "aws_iam_role" "gp-eks-node-group-role" {
  name = "${var.cluster_name}-node-group-role"  

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

resource "aws_iam_role_policy_attachment" "gp_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.gp-eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "gp_node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.gp-eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "gp_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.gp-eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}



# IAM Role for eks addons
data "aws_iam_policy_document" "gp_eks_addons_assume_role_policy" {
  statement {
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    effect = "Allow"

    condition {
      test = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.gp_eks.url, "https://", "")}:sub"
      values = [ "system:serviceaccount:kube-system:ebs-csi-controller-sa" ]
    }

    principals {
      identifiers = [ aws_iam_openid_connect_provider.gp_eks.arn ]
      type = "Federated"
    }
  }
}

resource "aws_iam_role" "gp_eks_addons" {
  name = "${var.cluster_name}-addons-role"
  assume_role_policy = data.aws_iam_policy_document.gp_eks_addons_assume_role_policy.json
}

resource "aws_iam_policy" "gp_ebs_csi_driver_policy" {
  name = "${var.cluster_name}-ebs-csi-driver-policy"
  description = ("IAM policy for EBS CSI Driver")
  policy = var.ebs_csi_driver_policy != "" ? file(var.ebs_csi_driver_policy) : <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeVolumes",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumeStatus",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeTags",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:ModifyVolume",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeRegions",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots"
        ],
        "Resource": "*"
      }
    ]
  }
POLICY
}

resource "aws_iam_policy_attachment" "gp_ebs_csi_driver_attach" {
  name       = "${var.cluster_name}-ebs-csi-driver-attach"
  policy_arn = aws_iam_policy.gp_ebs_csi_driver_policy.arn
  roles      = [aws_iam_role.gp_eks_addons.name]
  
}