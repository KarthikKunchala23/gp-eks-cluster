resource "aws_launch_template" "eks_nodes_lt" {
  name_prefix   = "${var.cluster_name}-lt"

  key_name = "jfrog_vm"
  ebs_optimized = true
  instance_type = var.node_instance_type

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.disk_size
      volume_type = "gp3"
    }
  }

  vpc_security_group_ids = [
    aws_security_group.eks_nodes_sg.id
  ]

  metadata_options {
    http_tokens = "required"
    http_put_response_hop_limit = 2
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}