output "kube_node_vm_ips" {
  description = "The IP addresses of the Kubernetes node VMs"
  value = jsonencode([
    for vm in proxmox_vm_qemu.kube_node : {
      name = vm.name
      ip   = split("/", split("=", split(",", vm.ipconfig0)[0])[1])[0] # Extract IP only, excluding the subnet mask
    }
  ])
}
