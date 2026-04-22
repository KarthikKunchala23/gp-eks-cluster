variable "vpc_config" {
  description = "VPC CIDR block details for the EKS cluster"
  type = object({
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "gp-eks-vpc"
  })
}

variable "subnet_config" {
  description = "Subnet CIDR block for the EKS cluster"
  type = object({
    subnet_cidr = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    subnet_name = "gp-eks-subnet"
    availability_zone = ["ap-south-1a", "ap-south-1c"]
    subnet_type = ["public", "public", "private", "private"]  #public/private 
  })
}