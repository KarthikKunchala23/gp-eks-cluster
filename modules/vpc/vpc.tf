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
    availability_zone = var.subnet_config.availability_zone[count.index % length(var.subnet_config.availability_zone)]
    map_public_ip_on_launch = var.subnet_config.subnet_type[count.index] == "public"
    tags = {
        Name = "${var.subnet_config.subnet_name}-${var.subnet_config.subnet_type[count.index]}-${count.index}"
        Type = var.subnet_config.subnet_type[count.index]
    }
}

resource "aws_internet_gateway" "gp-eks-igw" {
  vpc_id = aws_vpc.gp-eks-vpc.id

  tags = {
    Name = "${var.vpc_config.vpc_name}-igw"
  }
}

resource "aws_route_table" "gp-eks-public-rt" {
  vpc_id = aws_vpc.gp-eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gp-eks-igw.id
  }

  tags = {
    Name = "${var.vpc_config.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "gp-eks-private_rt" {
  vpc_id = aws_vpc.gp-eks-vpc.id

  tags = {
    Name = "${var.vpc_config.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "gp-eks-rt-association" {
  count = length(var.subnet_config.subnet_cidr)
  subnet_id = aws_subnet.gp-eks-subnet[count.index].id

  route_table_id = var.subnet_config.subnet_type[count.index] == "public" ? aws_route_table.gp-eks-public-rt.id : aws_route_table.gp-eks-private_rt.id
}