#!/bin/bash

terraform apply -auto-approve \
    -var="proxmox_api_url=https://192.168.5.3:8006/api2/json" \
    -var="proxmox_api_token_id=root@pam!packer" \
    -var="proxmox_api_token_secret=d60b5bf0-acd6-436b-9dfa-52b12d84866a" \
    -var="proxmox_api_insecure=true"

# Define output files
HAProxy_IPS_FILE="../ansible/hosts/haproxy_ips.json"
KubeCP_IPS_FILE="../ansible/hosts/kube_cp_ips.json"
KubeNode_IPS_FILE="../ansible/hosts/kube_node_ips.json"

# Ensure the output directory exists
mkdir -p "$(dirname "$HAProxy_IPS_FILE")"

# Retrieve and format Terraform outputs in proper JSON format
terraform output -json haproxy_vm_ips | jq 'fromjson' > "$HAProxy_IPS_FILE"
terraform output -json kube_cp_vm_ips | jq 'fromjson' > "$KubeCP_IPS_FILE"
terraform output -json kube_node_vm_ips | jq 'fromjson' > "$KubeNode_IPS_FILE"

echo "Terraform outputs saved successfully."
