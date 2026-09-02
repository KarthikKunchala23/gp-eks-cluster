# resource "aws_eks_pod_identity_association" "catalog" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "default"
#   service_account = "catalog"
#   role_arn        = aws_iam_role.catalog_role.arn
#   depends_on = [
#     aws_iam_role_policy_attachment.catalog_policy_attachment
#   ]
# }

# resource "aws_eks_pod_identity_association" "orders_secrets" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "default"
#   service_account = "orders"
#   role_arn        = aws_iam_role.orders_role.arn
#   depends_on = [
#     aws_iam_role_policy_attachment.orders_policy_attachment
#   ]
# }

# resource "aws_eks_pod_identity_association" "orders_sqs" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "default"
#   service_account = "orders"
#   role_arn        = data.aws_iam_role.orders_role.arn
# }

# resource "aws_eks_pod_identity_association" "carts" {
#   cluster_name    = module.eks.cluster_name
#   namespace       = "default"
#   service_account = "carts"
#   role_arn        = data.aws_iam_role.carts_role.arn
# }
