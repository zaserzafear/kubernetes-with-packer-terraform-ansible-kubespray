#!/bin/bash

# Define paths for input files and output files
HAPROXY_JSON_FILE="../hosts/haproxy_ips.json"  # JSON file containing HAProxy nodes IPs
KUBE_CP_JSON_FILE="../hosts/kube_cp_ips.json"  # JSON file containing Kubernetes control plane nodes IPs
KUBE_NODE_JSON_FILE="../hosts/kube_node_ips.json"  # JSON file containing Kubernetes node nodes IPs
INVENTORY_FILE="inventory.yml"  # Output YAML file for the Ansible inventory
KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"  # SSH known hosts file to manage known hosts

# Check if JSON files exist
# If either JSON file does not exist, print an error and exit
if [ ! -f "$HAPROXY_JSON_FILE" ]; then
  echo "Error: JSON file $HAPROXY_JSON_FILE does not exist."
  exit 1
fi

if [ ! -f "$KUBE_CP_JSON_FILE" ]; then
  echo "Error: JSON file $KUBE_CP_JSON_FILE does not exist."
  exit 1
fi

if [ ! -f "$KUBE_NODE_JSON_FILE" ]; then
  echo "Error: JSON file $KUBE_NODE_JSON_FILE does not exist."
  exit 1
fi

# Initialize the YAML file with base structure for HAProxy and Kubernetes control plane
echo "---" > "$INVENTORY_FILE"  # Start the YAML file with the document separator
echo "haproxy:" >> "$INVENTORY_FILE"  # Add HAProxy section header
echo "  hosts:" >> "$INVENTORY_FILE"  # Initialize hosts section for HAProxy
echo "kube-cp:" >> "$INVENTORY_FILE"  # Add Kubernetes control plane section header
echo "  hosts:" >> "$INVENTORY_FILE"  # Initialize hosts section for Kubernetes control plane

# Variables for Ansible settings
ANSIBLE_USER="ubuntu"  # Ansible user to use for remote connections
ANSIBLE_BECOME="yes"  # Enable privilege escalation
ANSIBLE_BECOME_METHOD="sudo"  # Use sudo for privilege escalation

# Remove old SSH host keys
# Check if the known hosts file exists and remove outdated keys for the IPs in JSON files
if [ -f "$KNOWN_HOSTS_FILE" ]; then
  while IFS= read -r host; do
    # Remove SSH keys associated with the old IP addresses from known hosts file
    ssh-keygen -f "$KNOWN_HOSTS_FILE" -R "$host"
  done < <(jq -r '.[] | .ip' "$HAPROXY_JSON_FILE" "$KUBE_CP_JSON_FILE")
else
  echo "Error: Known hosts file $KNOWN_HOSTS_FILE does not exist."
  exit 1
fi

# Read HAProxy JSON file and append nodes to the YAML inventory
jq -c '.[]' "$HAPROXY_JSON_FILE" | while IFS= read -r item; do
  VM_NAME=$(echo "$item" | jq -r '.name')  # Extract node name
  VM_IP=$(echo "$item" | jq -r '.ip')  # Extract node IP

  # Update YAML file for HAProxy nodes with relevant Ansible settings
  yq eval -i "
    .haproxy.hosts.\"$VM_NAME\".ansible_host = \"$VM_IP\" |
    .haproxy.hosts.\"$VM_NAME\".ansible_user = \"$ANSIBLE_USER\" |
    .haproxy.hosts.\"$VM_NAME\".ansible_become = \"$ANSIBLE_BECOME\" |
    .haproxy.hosts.\"$VM_NAME\".ansible_become_method = \"$ANSIBLE_BECOME_METHOD\"
  " "$INVENTORY_FILE"
  done

# Read Kubernetes control plane JSON file and append nodes to the YAML inventory
jq -c '.[]' "$KUBE_CP_JSON_FILE" | while IFS= read -r item; do
  VM_NAME=$(echo "$item" | jq -r '.name')  # Extract node name
  VM_IP=$(echo "$item" | jq -r '.ip')  # Extract node IP

  # Update YAML file for Kubernetes control plane nodes with relevant Ansible settings
  yq eval ".\"kube-cp\".hosts.\"$VM_NAME\".ansible_host = \"$VM_IP\"" "$INVENTORY_FILE" -i
done

# Read Kubernetes node JSON file and append nodes to the YAML inventory
jq -c '.[]' "$KUBE_NODE_JSON_FILE" | while IFS= read -r item; do
  VM_NAME=$(echo "$item" | jq -r '.name')  # Extract node name
  VM_IP=$(echo "$item" | jq -r '.ip')  # Extract node IP

  # Update YAML file for Kubernetes node nodes with relevant Ansible settings
  yq eval ".\"kube-node\".hosts.\"$VM_NAME\".ansible_host = \"$VM_IP\"" "$INVENTORY_FILE" -i
done

# Print a success message indicating where the inventory file was generated
echo "Inventory file generated successfully at $INVENTORY_FILE."

# Run the Ansible playbook to set up HAProxy using the generated inventory file
ansible-playbook -i inventory.yml haproxy_setup.yml
