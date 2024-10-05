# kubernetes node module settings
kube_node_vm_config = [
  {
    vmid        = 1231
    ip          = "192.168.5.205"
    target_node = "pve"
  },
  # {
  #   vmid        = 1032
  #   ip          = "192.168.5.206"
  #   target_node = "pve"
  # },
  # {
  #   vmid        = 1033
  #   ip          = "192.168.5.207"
  #   target_node = "pve"
  # },
]
kube_node_storage          = "local-nvme"
kube_node_storage_format   = "raw"
kube_node_storage_size     = "40G"
kube_node_ci_user          = "ubuntu-server"
kube_node_ci_password      = "P@ssw0rd"
kube_node_template         = "ubuntu-server-jammy"
kube_node_startup          = "order=3"
kube_node_memory           = 8192
kube_node_cpu              = "host"
kube_node_cpu_numa         = true
kube_node_cpu_sockets      = 1
kube_node_cpu_cores        = 4
kube_node_gateway          = "192.168.5.1"
kube_node_subnet           = "24"
kube_node_nameserver       = "192.168.5.1"
kube_node_network_model    = "virtio"
kube_node_network_bridge   = "vmbr0"
kube_node_network_tag      = 200
kube_node_network_firewall = true
