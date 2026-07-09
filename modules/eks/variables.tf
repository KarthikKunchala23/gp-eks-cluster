variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "region" {
  description = "AWS region for the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "node_instance_type" { type = string }
variable "node_min_size" { type = number }
variable "node_desired_size" { type = number }
variable "node_max_size" { type = number }
variable "ami_type" {
  type = string
}

variable "encryption_config" {
  description = "EKS cluster encryption configuration"
  type = object({
    kms_key_arn = string
    resources   = list(string)
  })
}

variable "disk_size" {
  description = "Disk size for EKS worker nodes (in GB)"
  type        = number
  default     = 20
}

variable "env" {
  description = "Environment tag for resources"
  type        = string
  default     = "dev"
}

variable "ebs_csi_driver_policy" {
  description = "IAM Policy for EBS CSI DRIVER"
  type        = string
  default     = ""
}

variable "public_cidr" {
  description = "Public Ip CIDR to access EKS Endpoint"
  type = list(string)
  default = []
}

variable "bootstrap_self_managed_addons" {
  description = "Whether to keep add-ons self managed by cluster or custom managed"
  type        = bool
  default     = true
}

variable "endpoint_private_access" {
  description = "EKS Cluster endpoint private access"
  type = bool
  default = false
}

variable "endpoint_public_access" {
  description = "EKS Cluster endpoint public access"
  type = bool
  default = false
}