#!/bin/bash

# Initialize the inventory file by creating it empty
echo "" > inventory.yml

# Initialize the inventory file with the base structure using yq
# This creates empty structures for different groups and categories
yq eval "
  .all.hosts = {} |
  .all.children.kube_control_plane.hosts = {}  |
  .all.children.kube_node.hosts = {}  |
  .all.children.etcd.hosts = {} |
  .all.children.k8s_cluster.children.kube_control_plane = {} |
  .all.children.k8s_cluster.children.kube_node = {} |
  .all.children.calico_rr = {}
" -i inventory.yml

# Add control plane nodes to inventory.yml
# Read the kube control plane IPs from a JSON file and update the inventory
jq -c '.[]' ../hosts/kube_cp_ips.json | while read i; do
  name=$(echo $i | jq -r '.name')
  ip=$(echo $i | jq -r '.ip')

  # Update inventory with control plane node information
  yq eval "
  .all.hosts.$name.ansible_host = \"$ip\" |
  .all.hosts.$name.ip = \"$ip\" |
  .all.hosts.$name.access_ip = \"$ip\" |
  .all.children.kube_control_plane.hosts.$name = {} |
  .all.children.etcd.hosts.$name = {}
  " -i inventory.yml
done

# Add worker nodes to inventory.yml
# Read the worker node IPs from a JSON file and update the inventory
jq -c '.[]' ../hosts/kube_node_ips.json | while read i; do
  name=$(echo $i | jq -r '.name')
  ip=$(echo $i | jq -r '.ip')

  # Update inventory with worker node information
  yq eval "
  .all.hosts.$name.ansible_host = \"$ip\" |
  .all.hosts.$name.ip = \"$ip\" |
  .all.hosts.$name.access_ip = \"$ip\" |
  .all.children.kube_node.hosts.$name = {}
  " -i inventory.yml
done

# Update group_vars with load balancer and API server settings
# Set the domain name and address for the API server load balancer
yq eval '
  .apiserver_loadbalancer_domain_name = "lb-kube.cluster.local" |
  .loadbalancer_apiserver.address = "192.168.5.101" |
  .loadbalancer_apiserver.port = 6443 |
  .loadbalancer_apiserver_localhost = false
' -i ./group_vars/all/all.yml

# Update group_vars for Kubernetes cluster to use Docker as the container manager
yq e '
  .container_manager = "docker"
' -i ./group_vars/k8s_cluster/k8s-cluster.yml

# Run the KubeSpray Ansible playbook using Docker
# Bind the current directory and SSH key for access
docker run --rm -it \
  --mount type=bind,source="$(pwd)",dst=/inventory \
  --mount type=bind,source="${HOME}/.ssh/id_rsa",dst=/root/.ssh/id_rsa \
  --entrypoint ansible-playbook \
  quay.io/kubespray/kubespray:v2.25.0 \
  -i /inventory/inventory.yml \
  --become --become-user=root -u ubuntu \
  /kubespray/cluster.yml -K
