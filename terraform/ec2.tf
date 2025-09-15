resource "aws_key_pair" "generated_key" {
  public_key = file("${path.module}/my-ec2-key.pub")
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
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = var.instance_type
  subnet_id               = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.my_k8s_sg.id]
  key_name                = aws_key_pair.generated_key.key_name
  tags = {
    Name = "control-plane-node"
  }
}

resource "aws_instance" "worker_nodes" {
  count                   = 2
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  subnet_id               = module.vpc.public_subnets[count.index + 1]
  vpc_security_group_ids = [aws_security_group.my_k8s_sg.id]
  key_name                = aws_key_pair.generated_key.key_name
  tags = {
    Name = "worker-node-${count.index + 1}"
  }
}