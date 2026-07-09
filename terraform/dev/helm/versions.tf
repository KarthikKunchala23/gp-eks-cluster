terraform {
  required_version = ">= 1.0"
  required_providers {

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~>2.38.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "~>3.1.0"
    }
  }

  backend "s3" {
    bucket = "gp-project-s3-cindia"
    key    = "eks-addons-helm/terraform.tfstate"
    # dynamodb_table = "terraform-lock-table"
    use_lockfile = true
    region = "ap-south-1"
    encrypt = true
  }
}