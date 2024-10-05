output "kube_cp_vm_ips" {
  description = "The IP addresses of the Kubernetes control plane VMs"
  value = jsonencode([
    for vm in proxmox_vm_qemu.kube_cp : {
      name = vm.name
      ip   = split("/", split("=", split(",", vm.ipconfig0)[0])[1])[0] # Extract IP only, excluding the subnet mask
    }
  ])
}
