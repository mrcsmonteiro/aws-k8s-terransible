resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-ec2-key-tf"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key_file" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "my-ec2-key.pem"
  file_permission = "0400"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "control_plane" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.my_k8s_sg.id]
  key_name        = aws_key_pair.generated_key.key_name
  tags = {
    Name = "k8s-control-plane-node"
  }
}

resource "aws_instance" "worker_nodes" {
  count           = 2
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  subnet_id       = module.vpc.public_subnets[count.index + 1]
  security_groups = [aws_security_group.my_k8s_sg.id]
  key_name        = aws_key_pair.generated_key.key_name
  tags = {
    Name = "k8s-worker-node-${count.index + 1}"
  }
}