module "custom-addons-release" {
    source = "../../../modules/helm"
    vpc_id = data.terraform_remote_state.gp-eks-cluster.outputs.vpc_id
    cluster_name = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_name
    region = var.region
    aws_secrets_provider_name = var.aws_secrets_provider_name
    csi_secrets_store_name = var.csi_secrets_store_name
    karpenter_name = "karpenter-controller"
    chart_version = "1.8.2"
    namespace = "karpenter"
    create_namespace = true
    cluster_endpoint = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_endpoint
    sqs_queue_name = "gp-eks-dev-cluster-karpenter-interruption"

    depends_on = [ 
        data.aws_eks_cluster.this,
    ]
}