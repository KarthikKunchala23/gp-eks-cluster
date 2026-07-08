# Install AWS Secrets and Configuration Provider (ASCP)
resource "helm_release" "aws_secrets_provider" {
  depends_on = [
    aws_eks_addon.pia,
    aws_eks_node_group.gp-eks-node-group,      
    helm_release.secrets_store_csi_driver
  ]


  name       = "secrets-provider-aws"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"

  # Disable re-installation of CSI driver (already installed separately)
  set = [ 
    {
    name  = "secrets-store-csi-driver.install"
    value = "false"
  }
  ]

  # Wait for all pods to become ready
  wait            = true
  timeout         = 600
  cleanup_on_fail = true
}