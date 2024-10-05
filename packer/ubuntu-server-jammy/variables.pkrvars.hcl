# VM SSH Credentials
vm_ssh_username = "ubuntu"
vm_ssh_password = "ubuntu"

# ISO File
iso_file = "local:iso/ubuntu-22.04.3-live-server-amd64.iso"

# VM Configuration
pm_target_node           = "pve"
pm_vm_id                 = "1000"
vm_name                  = "ubuntu-server-jammy"
template_description     = "Ubuntu Server Jammy Template"
storage_pool             = "local-ssd"
disk_size                = "20G"
cloud_init_storage_pool  = "local-ssd"
network_bridge           = "vmbr0"
network_vlan             = 0

# HTTP Configuration
http_bind_address = "192.168.5.30"
