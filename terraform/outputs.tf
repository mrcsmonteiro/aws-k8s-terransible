output "master_public_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_public_ips" {
  value = aws_instance.worker_nodes[*].public_ip
}

output "ssh_command" {
  description = "SSH command to access the control plane node"
  value       = "ssh -i ${local_file.private_key_file.filename} ubuntu@${aws_instance.control_plane.public_ip}"
}