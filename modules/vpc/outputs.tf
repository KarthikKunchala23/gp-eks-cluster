output "vpc_id" {
  value = aws_vpc.gp-eks-vpc.id
}

output "public_subnet_ids" {
  value = [
    for s in aws_subnet.gp-eks-subnet :
    s.id if s.tags.Type == "public"
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"

  value = [
    for s in aws_subnet.gp-eks-subnet :
    s.id if s.tags.Type == "private"
  ]
}