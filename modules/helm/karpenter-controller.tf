resource "helm_release" "karpenter" {
  name             = var.karpenter_name
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace

  wait    = true
  timeout = 600

  set = [
    {
      name  = "settings.clusterName"
      value = var.cluster_name
    },
    {
      name  = "settings.clusterEndpoint"
      value = var.cluster_endpoint
    },
    {
      name  = "settings.interruptionQueue"
      value = var.sqs_queue_name
    },
    {
      name  = "serviceAccount.name"
      value = "karpenter"
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name = "replicas"
      value = "2"
    }
  ]

  depends_on = [
    helm_release.aws-load-balancer-controller
  ]
}