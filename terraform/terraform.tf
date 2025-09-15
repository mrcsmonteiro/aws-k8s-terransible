terraform {
  required_version = ">= 1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    control_plane_ip         = aws_instance.control_plane.public_ip
    worker_ips               = aws_instance.worker_nodes[*].public_ip
    control_plane_private_ip = aws_instance.control_plane.private_ip
    ssh_key_path             = "../terraform/${aws_key_pair.generated_key.key_name}"
  })
  filename = "../ansible/hosts.ini"
}
