module "eks" {
    source = "../../modules/eks"
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    cluster_role_arn = module.eks-iam.cluster_role_arn
    private_subnets = module.eks-vpc.private_subnet_ids
    encryption_config = var.encryption_config
    env = var.env
    ami_type = var.ami_type
    node_instance_type = var.node_instance_type
    node_desired_size = var.node_desired_size
    node_max_size = var.node_max_size
    node_min_size = var.node_min_size
    disk_size = var.disk_size
    vpc_id = module.eks-vpc.vpc_id
}