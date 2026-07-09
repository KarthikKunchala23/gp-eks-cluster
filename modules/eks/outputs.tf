
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
  value = aws_security_group.eks_cluster_sg.id
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

output "node_group_id" {
  description = "EKS Node Group"
  value = aws_eks_node_group.gp-eks-node-group.id
}


## Helm Release Outputs
# LBC Helm Release Outputs
# output "helm_lbc_metadata" {
#   description = "Metadata Block outlining status of the deployed release."
#   value = helm_release.aws-load-balancer-controller.metadata
# }


# ## Secrets Store CSI Driver Helm Release Outputs
# output "helm_secrets_store_csi_driver_metadata" {
#   description = "Metadata for the Secrets Store CSI Driver Helm release"
#   value       = helm_release.secrets_store_csi_driver.metadata
# }

# ## Secrets Store ASCP Helm Release Outputs
# output "helm_aws_secrets_provider_metadata" {
#   description = "Metadata for the AWS Secrets and Configuration Provider Helm release"
#   value       = helm_release.aws_secrets_provider.metadata
# }


## EBS CSI

## EBS CSI Driver Addon outputs
output "ebs_csi_addon_default_version" {
  description = "Default EBS CSI addon version compatible with the EKS cluster version"
  value       = data.aws_eks_addon_version.ebs_csi_default.version
}

output "ebs_csi_addon_latest_version" {
  description = "Latest available EBS CSI addon version for the current EKS cluster"
  value       = data.aws_eks_addon_version.ebs_csi_latest.version
}

output "ebs_csi_addon_arn" {
  description = "ARN of the installed EBS CSI addon"
  value       = aws_eks_addon.ebs_csi.arn
}

output "ebs_csi_addon_id" {
  description = "ID of the installed EBS CSI addon"
  value       = aws_eks_addon.ebs_csi.id
}

## EBS CSI Driver IAM Role outputs
output "ebs_csi_iam_role_arn" {
  description = "IAM Role ARN for Amazon EBS CSI Driver"
  value       = aws_iam_role.ebs_csi_iam_role.arn
}

## lbc iam 

## AWS Load Balancer Controller IAM Policy outputs
output "lbc_iam_policy_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM Policy"
  value       = aws_iam_policy.lbc-policy.arn
}

output "lbc_iam_role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM Role"
  value = aws_iam_role.lbc-role.arn
}

# PIA 

output "pia_addon_version_default" {
  description = "Default Version of the EKS Pod Identity Agent Addon"
  value       = data.aws_eks_addon_version.pia-default.version
}

output "pia_addon_version_latest" {
  description = "Latest Version of the EKS Pod Identity Agent Addon"
  value       = data.aws_eks_addon_version.pia-latest.version
}


output "pia_addon_arn" {
  description = "ARN of the EKS Pod Identity Agent Addon"
  value       = aws_eks_addon.pia.arn
}

output "pia_addon_id" {
  description = "ID of the EKS Pod Identity Agent Addon"
  value       = aws_eks_addon.pia.id
}

## EBS CSI Pod Identity Association ARN
output "ebs_csi_pod_identity_association_arn" {
  description = "EBS CSI Driver Pod Identity Association ARN"
  value       = aws_eks_pod_identity_association.ebs_csi.association_arn
}

output "lbc_pia_arn" {
  description = "Load Balancer Controller Pod Identity Association ARN"
  value = aws_eks_pod_identity_association.lbc-pia-association.association_arn
}