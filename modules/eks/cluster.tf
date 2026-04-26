resource "aws_eks_cluster" "gp-eks-cluster" {
    name = var.cluster_name

    access_config {
        authentication_mode = "API"
    }

    role_arn = aws_iam_role.gp-eks-cluster-role.arn
    version = var.kubernetes_version

    bootstrap_self_managed_addons = false

    enabled_cluster_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager",
        "scheduler"
    ]

    encryption_config {
        provider {
            key_arn = var.encryption_config.kms_key_arn
        }
        resources = var.encryption_config.resources
    }

    vpc_config {
        endpoint_private_access = true
        endpoint_public_access = false
        public_access_cidrs = [ "27.6.92.85/32" ]

        subnet_ids = var.private_subnets
        security_group_ids = [aws_security_group.eks_cluster_sg.id]
    }

    depends_on = [ 
        aws_iam_role_policy_attachment.gp-AmazonEKSClusterPolicy,
        aws_iam_role_policy_attachment.gp-AmazonEKSVPCResourceController,
        aws_iam_role_policy_attachment.gp_cluster_AmazonEKSComputePolicy,
        aws_iam_role_policy_attachment.gp_cluster_AmazonEKSBlockStoragePolicy,
        aws_iam_role_policy_attachment.gp_cluster_AmazonEKSLoadBalancingPolicy,
        aws_iam_role_policy_attachment.gp_cluster_AmazonEKSNetworkingPolicy
     ]
    
    tags = {
        Environment = var.env
        Terraform   = "true"
    }
}



resource "aws_iam_openid_connect_provider" "gp_eks" {
  url             = aws_eks_cluster.gp-eks-cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.gp-eks-cluster.identity[0].oidc[0].issuer
}

# -------------------------
# OIDC Provider for IRSA
# -------------------------

# Node group (managed node group)
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.gp-eks-cluster.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.gp-eks-node-group-role.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  capacity_type = "SPOT"
  launch_template {
    id = aws_launch_template.eks_nodes_lt.id
    version = "$Latest"
  }
  ami_type = var.ami_type != "" ? var.ami_type : "AL2023_x86_64_STANDARD"

  depends_on = [aws_eks_cluster.gp-eks-cluster]
}


# -------------------------
# EKS EBS CSI Driver Addon
# -------------------------
data "aws_eks_addon_version" "ebs_csi" {
  addon_name           = "aws-ebs-csi-driver"
  kubernetes_version   = aws_eks_cluster.gp-eks-cluster.version
  most_recent          = true
}
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.gp-eks-cluster.name
  addon_version = data.aws_eks_addon_version.ebs_csi.version
  addon_name   = "aws-ebs-csi-driver"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn = aws_iam_role.gp_eks_addons.arn

  depends_on = [
    aws_iam_role.gp_eks_addons,
    aws_iam_policy_attachment.gp_ebs_csi_driver_attach,
    aws_eks_cluster.gp-eks-cluster,
    aws_eks_node_group.default
  ]
}