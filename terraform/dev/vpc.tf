module "eks-vpc" {
  source = "../../modules/vpc"
  vpc_config = var.vpc_config
  subnet_config = var.subnet_config
}