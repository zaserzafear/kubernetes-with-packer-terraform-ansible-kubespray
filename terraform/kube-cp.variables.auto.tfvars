# kubernetes control plane module settings
kube_cp_vm_config = [
  {
    vmid        = 1221
    ip          = "192.168.5.202"
    target_node = "pve"
  },
  # {
  #   vmid        = 1022
  #   ip          = "192.168.5.103"
  #   target_node = "pve"
  # },
  # {
  #   vmid        = 1023
  #   ip          = "192.168.5.104"
  #   target_node = "pve"
  # },
]
kube_cp_storage          = "local-nvme"
kube_cp_storage_format   = "raw"
kube_cp_storage_size     = "40G"
kube_cp_ci_user          = "ubuntu-server"
kube_cp_ci_password      = "P@ssw0rd"
kube_cp_template         = "ubuntu-server-jammy"
kube_cp_startup          = "order=3"
kube_cp_memory           = 8192
kube_cp_cpu              = "host"
kube_cp_cpu_numa         = true
kube_cp_cpu_sockets      = 1
kube_cp_cpu_cores        = 2
kube_cp_gateway          = "192.168.5.1"
kube_cp_subnet           = "24"
kube_cp_nameserver       = "192.168.5.1"
kube_cp_network_model    = "virtio"
kube_cp_network_bridge   = "vmbr0"
kube_cp_network_tag      = 200
kube_cp_network_firewall = true
