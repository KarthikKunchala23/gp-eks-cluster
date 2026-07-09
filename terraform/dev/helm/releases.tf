module "custom-addons-release" {
    source = "../../../modules/helm"
    vpc_id = data.terraform_remote_state.gp-eks-cluster.outputs.vpc_id
    cluster_name = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_name
    region = var.region
    aws_secrets_provider_name = var.aws_secrets_provider_name
    csi_secrets_store_name = var.csi_secrets_store_name
}