variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "node_instance_type" { type = string }
variable "node_min_size" { type = number }
variable "node_desired_size" { type = number }
variable "node_max_size" { type = number }
variable "eks_cluster_sg" { type = string }
variable "ami_type" {
  type = string
}

variable "encryption_config" {
  description = "EKS cluster encryption configuration"
  type = list(object({
    provider = object({
      kms_key_arn = string
    })
    resources = list(string)
  }))
  default = []
  
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