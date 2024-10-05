resource "proxmox_vm_qemu" "haproxy" {
  for_each = { for config in var.haproxy_vm_config : config.vmid => config }

  name        = "${var.node_prefix}-${var.env_name}-haproxy-${each.value.vmid}"
  target_node = each.value.target_node
  vmid        = each.value.vmid
  desc        = "HAProxy ${each.key} - IP: ${each.value.ip}"
  bios        = "seabios"
  onboot      = true
  startup     = var.haproxy_startup
  agent       = 1
  clone       = var.haproxy_template
  full_clone  = true
  qemu_os     = "l26"

  memory  = var.haproxy_memory
  sockets = var.haproxy_cpu_sockets
  cores   = var.haproxy_cpu_cores
  cpu     = var.haproxy_cpu
  numa    = var.haproxy_cpu_numa

  scsihw  = "virtio-scsi-pci"
  os_type = "cloud-init"

  ciuser     = var.haproxy_ci_user
  cipassword = var.haproxy_ci_password
  sshkeys    = local.ssh_public_key

  nameserver = var.haproxy_nameserver
  ipconfig0  = "ip=${each.value.ip}/${var.haproxy_subnet},gw=${var.haproxy_gateway}"

  network {
    model    = var.haproxy_network_model
    bridge   = var.haproxy_network_bridge
    # tag      = var.haproxy_network_tag
    firewall = var.haproxy_network_firewall
  }

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = var.haproxy_storage
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          backup             = true
          cache              = "none"
          discard            = true
          format             = var.haproxy_storage_format
          size               = var.haproxy_storage_size
          storage            = var.haproxy_storage
        }
      }
    }
  }
}
