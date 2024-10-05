resource "proxmox_vm_qemu" "kube_cp" {
  depends_on = [proxmox_vm_qemu.haproxy]

  for_each = { for config in var.kube_cp_vm_config : config.vmid => config }

  name        = "${var.node_prefix}-${var.env_name}-kube-cp-${each.value.vmid}"
  target_node = each.value.target_node
  vmid        = each.value.vmid
  desc        = "Kubernetes Control Plane ${each.key} - IP: ${each.value.ip}"
  bios        = "seabios"
  onboot      = true
  startup     = var.kube_cp_startup
  agent       = 1
  clone       = var.kube_cp_template
  full_clone  = true
  qemu_os     = "l26"

  memory  = var.kube_cp_memory
  sockets = var.kube_cp_cpu_sockets
  cores   = var.kube_cp_cpu_cores
  cpu     = var.kube_cp_cpu
  numa    = var.kube_cp_cpu_numa

  scsihw  = "virtio-scsi-pci"
  os_type = "cloud-init"

  ciuser     = var.kube_cp_ci_user
  cipassword = var.kube_cp_ci_password
  sshkeys    = local.ssh_public_key

  nameserver = var.kube_cp_nameserver
  ipconfig0  = "ip=${each.value.ip}/${var.kube_cp_subnet},gw=${var.kube_cp_gateway}"

  network {
    model    = var.kube_cp_network_model
    bridge   = var.kube_cp_network_bridge
    # tag      = var.kube_cp_network_tag
    firewall = var.kube_cp_network_firewall
  }

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.kube_cp_storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          backup  = true
          cache   = "none"
          discard = true
          format  = var.kube_cp_storage_format
          size    = var.kube_cp_storage_size
          storage = var.kube_cp_storage
        }
      }
    }
  }
}
