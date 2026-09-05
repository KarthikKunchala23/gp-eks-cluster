module "eks" {
    source = "../../../modules/eks"
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    region = var.region
    kubernetes_version = var.cluster_version
    private_subnets = module.eks-vpc.private_subnet_ids
    encryption_config = {
        kms_key_arn = var.kms_key_arn
        resources = var.encryption_resources
    }
    env = var.env
    ami_type = var.ami_type
    node_instance_type = var.node_instance_type
    node_desired_size = var.node_desired_size
    node_max_size = var.node_max_size
    node_min_size = var.node_min_size
    disk_size = var.disk_size
    vpc_id = module.eks-vpc.vpc_id
    ebs_csi_driver_policy = var.ebs_csi_driver_policy   
    public_subnets = module.eks-vpc.public_subnet_ids
    depends_on = [ module.eks-vpc ]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_cidr             = var.public_cidr
    bootstrap_self_managed_addons = var.bootstrap_self_managed_addons
    # Add-ons 
    enable_aws_ebs_csi_driver = var.enable_aws_ebs_csi_driver
    ebs_csi_driver_role_arn = var.enable_aws_ebs_csi_driver ? aws_iam_role.ebs_csi_iam_role[0].arn : null
    # external_dns_service_account_role_arn = var.enable_external_dns ? aws_iam_role.externaldns_role[0].arn : null
    enable_external_dns = var.enable_external_dns
    enable_aws_pia = var.enable_aws_pia
    enable_metrics_server = var.enable_metrics_server
    pod_identities = ({
        karpenter = {
            namespace = "karpenter"
            service_account = "karpenter"
            role_arn = aws_iam_role.karpenter_controller.arn
        }
        lbc = {
            namespace = "kube-system"
            service_account = "aws-load-balancer-controller"
            role_arn = aws_iam_role.lbc-role.arn
        }
        ebs_csi_driver = {
            namespace = "kube-system"
            service_account = "ebs-csi-controller-sa"
            role_arn = var.enable_aws_ebs_csi_driver ? aws_iam_role.ebs_csi_iam_role[0].arn : null
        }
        external_dns = {
            namespace = "external-dns"
            service_account = "external-dns"
            role_arn = var.enable_external_dns ? aws_iam_role.externaldns_role[0].arn : null
        }
    })
}