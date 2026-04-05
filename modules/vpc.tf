resource "aws_vpc" "gp-eks-vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.cluster_name}-vpc"
    }
}

resource "aws_subnet" "gp-eks-subnet" {
    for_each = var.subnet_cidr
    vpc_id = aws_vpc.gp-eks-vpc.id
    cidr_block = each.value
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.cluster_name}-subnet"
    }
}