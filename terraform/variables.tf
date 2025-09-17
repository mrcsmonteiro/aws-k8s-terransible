variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the SSH key pair to access EC2 instances"
  default     = ".ssh/my-ec2-key.pem"
}