resource "aws_iam_role" "externaldns_role" {
  name = "${var.cluster_name}-externaldns-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "externaldns_managed_policy" {
  role       = aws_iam_role.externaldns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
