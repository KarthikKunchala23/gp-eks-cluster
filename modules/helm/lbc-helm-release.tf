resource "helm_release" "aws-load-balancer-controller" {
    # depends_on = [
    #     aws_eks_pod_identity_association.lbc-pia-association,
    #     aws_iam_role.lbc-role,
    #     aws_eks_node_group.gp-eks-node-group,
    #     aws_eks_addon.pia
    #     ]
    name       = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    namespace  = "kube-system"  

    wait = true
    timeout = "600"
    cleanup_on_fail = true

    set = [

        {
            name = "serviceAccount.create"
            value = true
        },

        {
            name = "serviceAccount.name"
            value = "aws-load-balancer-controller"
        },

        {
            name = "clusterName"
            value = var.cluster_name
        },

        {
            name = "region"
            value = var.region
        },

        {
            name = "vpcId"
            value = var.vpc_id
        }
        
    ]
}