variable "vpc_config" {
  description = "VPC CIDR block details for the EKS cluster"
  type = object({
    vpc_cidr = string
    vpc_name = string
  })
}

variable "subnet_config" {
  description = "Subnet CIDR block for the EKS cluster"
  type = object({
    subnet_cidr = list(string)
    subnet_name = string
    availability_zone = list(string)
    subnet_type = list(string)  #public/private 
  })
}
