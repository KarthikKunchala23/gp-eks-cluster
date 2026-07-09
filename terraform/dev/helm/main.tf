# HELM Provider
provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.gp-eks-cluster.outputs.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.gp-eks-cluster.outputs.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.this.token
}