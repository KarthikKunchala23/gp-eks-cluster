variable "vpc_config" {
  description = "VPC CIDR block details for the EKS cluster"  
  default = {
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "gp-eks-vpc"
  }
}

variable "subnet_config" {
  description = "Subnet CIDR block for the EKS cluster"
  default = {
    subnet_cidr       = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
    subnet_name       = "gp-eks-subnet"
    availability_zone = ["ap-south-1a", "ap-south-1c"]
    subnet_type       = ["public", "public", "private", "private", "database", "database"]
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "gp-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  default     = "1.34"
}

variable "kms_key_arn" {
  description = "EKS cluster encryption configuration"
  default     = "arn:aws:kms:ap-south-1:897722700244:key/c1f0ad65-949a-4909-baef-47383af4ecf2"
}

variable "encryption_resources" {
  description = "EKS cluster encryption configuration"
  default     = ["secrets"]
  
}
variable "env" {
  description = "Environment tag for resources"
  default     = "dev"
}

variable "ami_type" {
  description = "AMI type for EKS worker nodes"
  default     = "AL2023_x86_64_STANDARD"
}

variable "ebs_csi_driver_policy" {
  description = "IAM Policy for EBS CSI DRIVER"
  default     = ""
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes in the EKS cluster"
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes in the EKS cluster"
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes in the EKS cluster"
  default     = 3
}

variable "disk_size" {
  description = "instance size of eks nodes"
  default = 20
}

### Additional variables for VPC configuration of EKS
variable "endpoint_private_access" {
  description = "Enable private access to EKS API server endpoint"
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to EKS API server endpoint"
  default     = true
}

variable "public_cidr" {
  description = "CIDR block for public access to EKS API server endpoint"
  default     = ["106.215.175.87/32"]
}

variable "bootstrap_self_managed_addons" {
  description = "Whether to keep add-ons self managed by cluster or custom managed"
  type        = bool
  default     = true
}
