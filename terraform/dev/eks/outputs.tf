output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "vpc_id" {
  value = module.eks-vpc.vpc_id
}

output "karpenter_controller_role_arn" {
  description = "IAM role ARN for the Karpenter controller"
  value       = aws_iam_role.karpenter_controller.arn
}


# output "karpenter_controller_pod_identity_association" {
#   description = "Pod Identity association ID for the Karpenter controller"
#   value       = aws_eks_pod_identity_association.karpenter.id
# }

output "karpenter_node_role_name" {
  description = "IAM Role Name used by EC2 nodes launched by Karpenter"
  value       = aws_iam_role.karpenter_node.name
}

output "karpenter_node_role_arn" {
  description = "IAM Role ARN used by EC2 nodes launched by Karpenter"
  value       = aws_iam_role.karpenter_node.arn
}

output "karpenter_node_role_unique_id" {
  description = "Unique ID for the Karpenter node IAM role"
  value       = aws_iam_role.karpenter_node.unique_id
}

# output "pia-assc-karpenter" {
#   description = "pod identity association for karpenter"
#   value = aws_eks_pod_identity_association.karpenter.association_arn
# }