output "ssh_command" {
  description = "SSH command to access the control plane node"
  value       = "ssh -i ${var.ssh_key_name} ubuntu@${aws_instance.control_plane.public_ip}"
}

output "private_ip_control_plane" {
  description = "The private IP address of the control plane node"
  value       = aws_instance.control_plane.private_ip
}