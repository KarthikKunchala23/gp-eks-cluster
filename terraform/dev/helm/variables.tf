variable "vpc_id" {
  description = "vpc id for deploying helm"
  type = string
  default = ""
}

variable "region" {
  description = "region of eks cluster"
  type = string
  default = "ap-south-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
  default = ""
}

variable "aws_secrets_provider_name" {
    description = "secrets ASCP Name"
    type = string
    default = "aws-secrets-provider"
}

variable "csi_secrets_store_name" {
  description = "CSI SECRETS STORE NAME"
  type = string
  default = "csi-secrets-store"
}