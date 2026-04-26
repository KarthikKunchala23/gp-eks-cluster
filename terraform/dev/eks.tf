module "eks" {
    source = "../../modules/eks"
    cluster_name = var.cluster_name
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
}