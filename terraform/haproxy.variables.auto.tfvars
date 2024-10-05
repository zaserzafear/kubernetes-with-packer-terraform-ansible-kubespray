# haproxy module settings
haproxy_vm_config = [
  {
    vmid        = 1211
    ip          = "192.168.5.201"
    target_node = "pve"
  },
]
haproxy_storage          = "local-nvme"
haproxy_storage_format   = "raw"
haproxy_storage_size     = "20"
haproxy_ci_user          = "ubuntu-server"
haproxy_ci_password      = "P@ssw0rd"
haproxy_template         = "ubuntu-server-jammy"
haproxy_startup          = "order=2"
haproxy_memory           = 4096
haproxy_cpu              = "host"
haproxy_cpu_numa         = true
haproxy_cpu_sockets      = 1
haproxy_cpu_cores        = 1
haproxy_gateway          = "192.168.5.1"
haproxy_subnet           = "24"
haproxy_nameserver       = "192.168.5.1"
haproxy_network_model    = "virtio"
haproxy_network_bridge   = "vmbr0"
haproxy_network_tag      = 200
haproxy_network_firewall = true
