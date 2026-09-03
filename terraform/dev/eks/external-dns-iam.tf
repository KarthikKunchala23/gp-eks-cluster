resource "aws_iam_role" "externaldns_role" {
  count = var.enable_external_dns ? 1 : 0
  name = "${var.cluster_name}-externaldns-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "externaldns_managed_policy" {
  count = var.enable_external_dns ? 1 : 0
  role       = aws_iam_role.externaldns_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
