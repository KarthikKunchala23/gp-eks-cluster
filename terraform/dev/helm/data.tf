data "terraform_remote_state" "gp-eks-cluster" {
    backend = "s3"

    config = {
      bucket = "gp-project-s3-cindia"
      key = "eks/terraform.tfstate"
      region = "ap-south-1"
    }
}

data "aws_eks_cluster" "this" {
  name = data.terraform_remote_state.gp-eks-cluster.outputs.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}