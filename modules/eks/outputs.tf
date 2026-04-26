
output "cluster_name" {
  value = aws_eks_cluster.gp-eks-cluster.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.gp-eks-cluster.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.gp-eks-cluster.certificate_authority[0].data
}
output "cluster_security_group_id" {
  value = aws_security_group.gp-eks-cluster-sg.id
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL for the EKS cluster"
  value       = aws_eks_cluster.gp-eks-cluster.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for the EKS cluster"
  value       = aws_iam_openid_connect_provider.gp_eks.arn
  
}

output "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster"
  value = aws_iam_openid_connect_provider.gp_eks.url
}