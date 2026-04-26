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
  default = [
    {
      provider = {
        kms_key_arn = "arn:aws:kms:ap-south-1:897722700244:key/c1f0ad65-949a-4909-baef-47383af4ecf2"
      }
      resources = ["secrets"]
    }
  ]
  
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
