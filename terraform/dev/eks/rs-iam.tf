data "aws_iam_policy_document" "rs_app_assume" {
  statement {
    sid = "PodIdentity"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "catalog_policy" {
  name = "gp-catalog-db-secret-manager-policy_dev_catalog"
}

# data "aws_iam_policy" "orders_policy" {
#   name = "gp-orders-db-secret-manager-policy_dev_orders"
# }

# data "aws_iam_policy" "orders_sqs_policy" {
#   name = "orders-sqs-policy-retail-store"
# }

# data "aws_iam_role" "orders_role" {
#   name = "orders-sqs-role"
# }

# data "aws_iam_role" "carts_role" {
#   name = "carts-dynamo-role"
# }

# data "aws_iam_policy" "carts_policy" {
#   name = "gp-carts-dynamodb_dev_carts"
# }

resource "aws_iam_role" "catalog_role" {
  name               = "${module.eks.cluster_name}-catalog-role"
  assume_role_policy = data.aws_iam_policy_document.rs_app_assume.json
  tags               = var.tags
}

# resource "aws_iam_role" "orders_role" {
#   name               = "${module.eks.cluster_name}-orders-role"
#   assume_role_policy = data.aws_iam_policy_document.rs_app_assume.json
#   tags               = var.tags
# }

# resource "aws_iam_role" "carts_role" {
#   name               = "${module.eks.cluster_name}-carts-role"
#   assume_role_policy = data.aws_iam_policy_document.rs_app_assume.json
#   tags               = var.tags
# }

resource "aws_iam_role_policy_attachment" "catalog_policy_attachment" {
  role       = aws_iam_role.catalog_role.name
  policy_arn = data.aws_iam_policy.catalog_policy.arn
}

# resource "aws_iam_role_policy_attachment" "orders_policy_attachment" {
#   role       = aws_iam_role.orders_role.name
#   policy_arn = data.aws_iam_policy.orders_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "orders_sqs_policy_attachment" {
#   role       = aws_iam_role.orders_role.name
#   policy_arn = data.aws_iam_policy.orders_sqs_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "carts_policy_attachment" {
#   role       = aws_iam_role.carts_role.name
#   policy_arn = data.aws_iam_policy.carts_policy.arn
# }


resource "aws_eks_pod_identity_association" "catalog" {
  cluster_name    = module.eks.cluster_name
  namespace       = "default"
  service_account = "catalog"
  role_arn        = aws_iam_role.catalog_role.arn
  depends_on = [
    aws_iam_role_policy_attachment.catalog_policy_attachment
  ]
}

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
