[all]
control_plane ansible_host=${control_plane_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}
worker_node_1 ansible_host=${worker_ips[0]} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}
worker_node_2 ansible_host=${worker_ips[1]} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}

[workers]
worker_node_1
worker_node_2

[all:vars]
ansible_python_interpreter=/usr/bin/python3