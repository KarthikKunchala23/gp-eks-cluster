# module "karpenter-controller" {
#   source = "../../../modules/helm"
#   karpenter_name = "karpenter-controller"
#   chart_version = "1.8.2"
#   namespace = "karpenter"
#   create_namespace = true
#   cluster_name = data.aws_eks_cluster.this.name
#   cluster_endpoint = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_endpoint
#   sqs_queue_name = "gp-eks-dev-karpenter-interruption"
#   region = data.aws_region.current.name
#   vpc_id = data.terraform_remote_state.gp-eks-cluster.outputs.vpc_id
#   csi_secrets_store_name = "csi-secrets-store"
#   aws_secrets_provider_name = "aws-secrets-provider"
# }