variable "vpc_cidr" {
  description = "VPC CIDR block for the EKS cluster"
  type = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block for the EKS cluster"
  type = list(string)
}

variable "availability_zone" {
  description = "Availability zone for the EKS cluster"
  type = string
}