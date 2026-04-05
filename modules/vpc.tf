resource "aws_vpc" "gp-eks-vpc" {
    cidr_block = var.vpc_config.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_config.vpc_name
    }
}

resource "aws_subnet" "gp-eks-subnet" {
    count = length(var.subnet_config.subnet_cidr)
    vpc_id = aws_vpc.gp-eks-vpc.id
    cidr_block = var.subnet_config.subnet_cidr[count.index]
    availability_zone = var.subnet_config.availability_zone
    map_public_ip_on_launch = var.public_or_private
    tags = {
        Name = "${var.subnet_config.subnet_name}-${count.index}"
    }
}

resource "aws_route_table" "gp-eks-rt" {
  vpc_id = aws_vpc.gp-eks-vpc.id
  tags = {
    Name = "${var.cluster_name}-rt"
  }
}

resource "aws_route_table_association" "gp-eks-rt-association" {
  count = length(var.subnet_config.subnet_cidr)
  subnet_id = aws_subnet.gp-eks-subnet[count.index].id
  route_table_id = aws_route_table.gp-eks-rt.id
}