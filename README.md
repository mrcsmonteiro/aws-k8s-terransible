![AWS Terransible K8s Cluster](AWS_Terransible_K8s_cluster.png)

![Static Badge](https://img.shields.io/badge/Terraform-v1.13.2-blue) ![Static Badge](https://img.shields.io/badge/Ansible_core-2.16.3-blue) ![Static Badge](https://img.shields.io/badge/AWS_CLI-2.27.49-blue) ![Static Badge](https://img.shields.io/badge/Python-3.13.4-blue) ![Static Badge](https://img.shields.io/badge/Ubuntu-22.04.5_LTS-blue) ![Static Badge](https://img.shields.io/badge/Kubernetes-v1.34.1-blue) ![Static Badge](https://img.shields.io/badge/Kustomize-v5.7.1-blue) ![Static Badge](https://img.shields.io/badge/Helm-v3.19.0-blue)

## Table of Contents
- [Overview](#overview)
- [Usage](#usage)

## Overview

This project provisions a foundational Kubernetes cluster on AWS using Terraform and Ansible. The infrastructure is defined as code and includes the following components:

### Terraform Provisioning Overview

- **Virtual Private Cloud (VPC)**: A dedicated, isolated network to host all resources, including public subnets across multiple availability zones.
- **EC2 Instances**: Three Ubuntu EC2 instances are created to serve as the cluster nodes:
 - One `control-plane-node`
 - Two worker-node instances (named `worker-node-1` and `worker-node-2`).
- **Security Groups**: A security group is created to manage network traffic to and from the cluster nodes, with rules configured to allow SSH, Kubernetes API server traffic, and NodePort services.
- **Networking**: An Internet Gateway, Route Tables, and Route Table Associations are configured to enable public internet access for the cluster.
- **SSH Key Pair**: A new SSH key pair is generated to securely access the EC2 instances. The private key is saved locally to enable Ansible provisioning.
- **Ansible Inventory File**: An Ansible inventory file (`hosts.ini`) is dynamically generated to enable remote provisioning of the cluster nodes using Ansible playbooks.

### Ansible Provisioning Overview

The Ansible playbooks automate the setup and configuration of the Kubernetes cluster across the control plane node and worker nodes previosly deployed by Terraform to AWS. Here are the key configurations performed by Ansible:

- **System Prerequisites**: Prepares all nodes by installing essential packages, disabling swap, and configuring kernel modules and sysctl settings necessary for Kubernetes to run correctly.
- **Container Runtime**: Installs and configures Containerd as the container runtime on all nodes. It sets the systemd cgroup driver and ensures the service is running.
- **Kubernetes Installation**:
 - Adds the official Kubernetes APT repository and GPG key to all hosts.
 - Installs kubelet, kubeadm, and kubectl binaries.
- **Cluster Initialization**:
 - **Control Plane Node**: The playbook initializes the Kubernetes cluster on the control plane node using `kubeadm init`, specifying the API server's advertise address and the Calico pod network CIDR.
 - **Worker Nodes**: Worker nodes are then securely joined to the cluster using a join command generated from the control plane node.
- **Post-Installation Tasks**:
 - **Calico CNI**: Installs Calico as the Container Network Interface (CNI) to enable pod-to-pod communication.
 - **Metrics Server**: Deploys the Metrics Server, a crucial add-on for resource monitoring, and patches its configuration to work correctly within the cluster.
 - **Helm**: Installs the Helm package manager, allowing for easy deployment and management of applications in the cluster.
 - **User Configuration**: Sets up a convenient environment for the user by adding aliases and autocompletion for `kubectl` to the `.bashrc` file.

### Features
- **AWS Infrastructure as Code**: Uses Terraform to provision all necessary cloud resources on AWS, including EC2 instances for the cluster nodes, a dedicated VPC, security groups, and an SSH key pair.
- **Dynamic Inventory**: The infrastructure setup automatically generates an Ansible inventory file, ensuring the provisioning process is seamless and repeatable.
- **Ansible Provisioning**: A robust Ansible playbook automates the entire cluster setup, from installing prerequisites to deploying core Kubernetes components.
- **Kubernetes Components**: Deploys a minimum viable Kubernetes cluster with `kubeadm`, including the Containerd runtime and Calico CNI for networking.
- **Essential Add-ons**: Automatically installs key add-ons like the Metrics Server and the Helm package manager to enhance cluster functionality.
- **User-Friendly Setup**: Configures the cluster for immediate use by adding aliases and autocompletion for kubectl to streamline command-line interactions.

### Technologies
- **AWS**: The cloud provider where all the project's infrastructure (virtual machines, networking, etc.) is hosted and managed.
- **Terraform**: An open-source Infrastructure as Code (IaC) tool used to **provision the cloud resources** on AWS, including the EC2 instances, VPC, and security groups.
- **Ansible**: An open-source automation tool used to **configure and provision the software** on the EC2 instances. It handles tasks like installing Kubernetes components, configuring the container runtime, and setting up the cluster.
- **Kubernetes**: An open-source container orchestration platform that **automates the deployment, scaling, and management of containerized applications**.
- **Helm**: The package manager for Kubernetes. It simplifies the process of **defining, installing, and upgrading applications** within the cluster.
- **Kustomize**: A tool that helps **customize raw, template-free YAML files for multiple purposes**. It's used for declarative management of Kubernetes manifests.
- **Metrics Server**: A scalable, an in-memory application that **collects resource usage data** from Kubelets in the cluster and makes it available to the Kubernetes API. It's a key component for features like `kubectl top`.

## Usage

### Prerequisites
- Install Terraform (v1.13 or higher)
- Install Ansible (v2.16 or higher)
- Install git (v2 or higher)
- Install AWS CLI (v2 or higher)
- Configure and export AWS credentials to environment variables in your shell session:

   ```bash
   export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY_ID"
   export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_ACCESS_KEY"
   export AWS_REGION="YOUR_AWS_REGION"
   ```

> **Note**: using environment variables keeps sensitive information out of your codebase. This prevents accidental exposure of your AWS access keys in version control systems like Git. This practice is crucial for protecting your account from unauthorized access, especially when working in a team or on open-source projects.

### Deployment
1. **Clone the repository:**
   ```bash
   git clone https://github.com/mrcsmonteiro/aws-k8s-terransible.git
   ```
2. **Change to the terraform folder:**
   ```bash
   cd aws-k8s-terransible/terraform
   ```
3. **Inspect the `variables.tf` file and change its default values according to your preferences:**
   ```bash
   cat variables.tf
   ```
4. **Initialize Terraform:**
   ```bash
   terraform init
   ```
5. **Validate the templates:**
   ```bash
   terraform validate
   ```
6. **Create a plan and save the output:**
   ```bash
   terraform plan -out k8s.tfplan
   ```
7. **Apply the infrastructure:**
   ```bash
   terraform apply k8s.tfplan
   ```
8. **Use the Terraform output to SSH into your control-plane node and play with your Kubernetes cluster:**
   ```bash
   ssh -i .ssh/my-ec2-key.pem ubuntu@<YOUR_EC2_PUBLIC_IP>
   ```
8. **To avoid incurring costs, destroy your AWS resources when you no longer need them:**
   ```bash
   terraform destroy
   ```