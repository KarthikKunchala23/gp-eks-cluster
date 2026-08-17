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

# karpenter variables

variable "karpenter_name" {
  description = "Name of the Karpenter Controller"
  type = string
}

variable "cluster_endpoint" {
  description = "endpoint of eks cluster"
  type = string
}

variable "chart_version" {
  description = "Version of Karpenter helm chart"
  type = string
  default = "1.8.2"
}

variable "namespace" {
  description = "Namespace to deploy controller"
  type = string
  default = "kube-system"
}

variable "create_namespace" {
  description = "Whether to create a namespace for controller"
  type = bool
  default = false
}

variable "sqs_queue_name" {
  description = "SQS Queue name for spot interuptions"
  type = string
}