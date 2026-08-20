module "eks-vpc" {
  source = "../../../modules/vpc"
  vpc_config = var.vpc_config
  subnet_config = var.subnet_config
  cluster_name = "gp-eks-dev-cluster"
}