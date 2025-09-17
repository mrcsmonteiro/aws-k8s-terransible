output "ssh_command" {
  description = "SSH command to access the control plane node"
  value       = "ssh -i ${var.ssh_key_name} ubuntu@${aws_instance.control_plane.public_ip}"
}