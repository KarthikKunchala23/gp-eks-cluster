resource "aws_launch_template" "eks_nodes_lt" {
  name_prefix   = "${var.cluster_name}-lt"

  vpc_security_group_ids = [
    aws_security_group.eks_nodes_sg.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}