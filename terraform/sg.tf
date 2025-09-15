resource "aws_security_group" "my_k8s_sg" {
  name        = "my-k8s-sg"
  vpc_id      = module.vpc.vpc_id
  description = "Security group for my Kubernetes cluster"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow kube-apiserver communication
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Can be restricted to your VPC CIDR for production
  }

  # Allow etcd client and peer communication
  ingress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"
    self      = true # Allows etcd peers to talk to each other
  }

  # Allow kubelet API communication
  ingress {
    from_port = 10250
    to_port   = 10250
    protocol  = "tcp"
    self      = true
  }

  # Allow kube-proxy communication
  ingress {
    from_port = 10256
    to_port   = 10256
    protocol  = "tcp"
    self      = true
  }

  # Allow kube-controller-manager health checks
  ingress {
    from_port = 10257
    to_port   = 10257
    protocol  = "tcp"
    self      = true
  }

  # Allow kube-scheduler health checks
  ingress {
    from_port = 10259
    to_port   = 10259
    protocol  = "tcp"
    self      = true
  }

  # Allow NodePort Services (30000-32767)
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic within the security group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}