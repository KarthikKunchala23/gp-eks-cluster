
## Helm Release Outputs
# LBC Helm Release Outputs
output "helm_lbc_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.aws-load-balancer-controller.metadata
}


# ## Secrets Store CSI Driver Helm Release Outputs
output "helm_secrets_store_csi_driver_metadata" {
  description = "Metadata for the Secrets Store CSI Driver Helm release"
  value       = helm_release.secrets_store_csi_driver.metadata
}

# ## Secrets Store ASCP Helm Release Outputs
output "helm_aws_secrets_provider_metadata" {
  description = "Metadata for the AWS Secrets and Configuration Provider Helm release"
  value       = helm_release.aws_secrets_provider.metadata
}