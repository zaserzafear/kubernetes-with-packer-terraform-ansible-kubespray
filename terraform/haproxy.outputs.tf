output "haproxy_vm_ips" {
  description = "The IP addresses of the HAProxy VMs"
  value = jsonencode([
    for vm in proxmox_vm_qemu.haproxy : {
      name = vm.name
      ip   = split("/", split("=", split(",", vm.ipconfig0)[0])[1])[0]
    }
  ])
}
