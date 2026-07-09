variable "vpc_id" {
  description = "vpc id for deploying helm"
  type = string
}

variable "region" {
  description = "region of eks cluster"
  type = string
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type = string
}

variable "aws_secrets_provider_name" {
    description = "secrets ASCP Name"
    type = string
}

variable "csi_secrets_store_name" {
  description = "CSI SECRETS STORE NAME"
  type = string
}