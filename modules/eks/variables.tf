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
variable "node_instance_type" { type = list(string) }
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


# addon variables

variable "enable_aws_ebs_csi_driver" {
  description = "Enable AWS EBS CSI Driver"
  type        = bool
  default     = false
}

variable "enable_aws_pia" {
  description = "Enable AWS Pod Identity add-on"
  type        = bool
  default     = true
}

variable "enable_external_dns" {
  description = "Enable External DNS add-on"
  type        = bool
  default     = false
}

variable "enable_metrics_server" {
  description = "Enable Metrics Server add-on"
  type        = bool
  default     = false
}

variable "pod_identities" {
  description = "Map of pod identities to be created in the EKS cluster"
  type = map(object({
    namespace = string
    service_account = string
    role_arn = string
  }))
  default = {}
}

# variable "external_dns_service_account_role_arn" {
#   description = "ARN of the IAM role for External DNS service account"
#   type        = string
#   default     = ""
# }

variable "ebs_csi_driver_policy" {
  description = "IAM Policy for EBS CSI DRIVER"
  type        = string
  default     = ""
}

variable "ebs_csi_driver_role_arn" {
  description = "ARN of the IAM role for EBS CSI Driver service account"
  type        = string
  default     = ""
}