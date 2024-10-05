resource "proxmox_vm_qemu" "kube_node" {
  depends_on = [proxmox_vm_qemu.kube_cp]
  for_each = { for config in var.kube_node_vm_config : config.vmid => config }

  name        = "${var.node_prefix}-${var.env_name}-kube-node-${each.value.vmid}"
  target_node = each.value.target_node
  vmid        = each.value.vmid
  desc        = "Kubernetes Node ${each.key} - IP: ${each.value.ip}"
  bios        = "seabios"
  onboot      = true
  startup     = var.kube_node_startup
  agent       = 1
  clone       = var.kube_node_template
  full_clone  = true
  qemu_os     = "l26"

  memory  = var.kube_node_memory
  sockets = var.kube_node_cpu_sockets
  cores   = var.kube_node_cpu_cores
  cpu     = var.kube_node_cpu
  numa    = var.kube_node_cpu_numa

  scsihw  = "virtio-scsi-pci"
  os_type = "cloud-init"

  ciuser     = var.kube_node_ci_user
  cipassword = var.kube_node_ci_password
  sshkeys    = local.ssh_public_key

  nameserver = var.kube_node_nameserver
  ipconfig0  = "ip=${each.value.ip}/${var.kube_node_subnet},gw=${var.kube_node_gateway}"

  network {
    model    = var.kube_node_network_model
    bridge   = var.kube_node_network_bridge
    # tag      = var.kube_node_network_tag
    firewall = var.kube_node_network_firewall
  }

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.kube_node_storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          backup             = true
          cache              = "none"
          discard            = true
          format             = var.kube_node_storage_format
          size               = var.kube_node_storage_size
          storage            = var.kube_node_storage
        }
      }
    }
  }
}
