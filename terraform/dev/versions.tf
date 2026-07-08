data "aws_eks_cluster_auth" "gp-eks-cluster" {
  name = module.eks.cluster_id
}


terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.35.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~>2.38.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~>3.1.0"
    }

    http = {
      source = "hashicorp/http"
      version = "~>3.5.0"
    }
  }

  backend "s3" {
    bucket = "gp-project-s3-cindia"
    key    = "eks/terraform.tfstate"
    # dynamodb_table = "terraform-lock-table"
    use_lockfile = true
    region = "ap-south-1"
    encrypt = true
  }
}

# AWS Provider
provider "aws" {
  region = var.region
}

# HELM Provider
provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.gp-eks-cluster.token
  }
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host = module.eks.cluster_endpoint 
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.gp-eks-cluster.token
}