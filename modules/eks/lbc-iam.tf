resource "aws_iam_policy" "lbc-policy" {
  name = "{aws_eks_cluster.gp-eks-cluster.name}-AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  path = "/"
  policy = data.http.lbc-iam-policy.body
}

resource "aws_iam_role" "lbc-role" {
    name = "{aws_eks_cluster.gp-eks-cluster.name}-AWSLoadBalancerControllerRole"
    assume_role_policy = data.aws_iam_policy_document.pod_assume_role.json

    tags = {
        Name = "{aws_eks_cluster.gp-eks-cluster.name}-AWSLoadBalancerControllerRole"
        Environment = var.env
        Component = "LoadBalancerController"
    }
}

resource "aws_iam_role_policy_attachment" "lbc-policy-attachment" {
    role = aws_iam_role.lbc-role.name
    policy_arn = aws_iam_policy.lbc-policy.arn
}