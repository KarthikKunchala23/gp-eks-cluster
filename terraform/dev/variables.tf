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
    subnet_cidr       = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_name       = "gp-eks-subnet"
    availability_zone = ["ap-south-1a", "ap-south-1c"]
    subnet_type       = ["public", "public", "private", "private"]
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "gp-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  default     = "1.31"
}

variable "encryption_config" {
  description = "EKS cluster encryption configuration"
  default = []
}

variable "env" {
  description = "Environment tag for resources"
  default     = "dev"
}

variable "ami_type" {
  description = "AMI type for EKS worker nodes"
  default     = "AL2_x86_64"
}

variable "ebs_csi_driver_policy" {
  description = "IAM Policy for EBS CSI DRIVER"
  default     = ""
}

