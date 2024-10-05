# Variables Definition
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_api_insecure" {
  type      = bool
  sensitive = true
  default   = true
}

variable "pm_target_node" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "template_description" {
  type = string
}

variable "pm_vm_id" {
  type    = string
  default = "0"
}

variable "iso_file" {
  type = string
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_vlan" {
  type    = number
  default = 0
}

variable "cloud_init_storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "http_bind_address" {
  type    = string
  default = "0.0.0.0"
}

variable "vm_ssh_username" {
  type      = string
  sensitive = true
}

variable "vm_ssh_password" {
  type      = string
  sensitive = true
}

packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Source Configuration for the VM Template
source "proxmox-iso" "ubuntu-server-jammy" {
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = var.proxmox_api_insecure

  node                     = var.pm_target_node
  vm_name                  = var.vm_name
  template_description     = var.template_description
  vm_id                    = var.pm_vm_id
  iso_file                 = var.iso_file
  unmount_iso              = true

  qemu_agent = true

  # Disk Configuration
  scsi_controller = "virtio-scsi-pci"
  disks {
    type         = "virtio"
    storage_pool = var.storage_pool
    disk_size    = var.disk_size
    format       = "raw"
    discard      = true
  }

  # CPU and Memory Configuration
  cores    = 2
  cpu_type = "host"
  numa     = true
  memory   = 2048

  # Network Configuration
  network_adapters {
    model    = "virtio"
    bridge   = var.network_bridge
    firewall = true
    
    vlan_tag = "${var.network_vlan != 0 ? var.network_vlan : ""}"
  }

  # Cloud-Init Configuration
  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  # Boot Command
  boot_command = [
    "<esc><wait5>",
    "e<wait3>",
    "<down><down><down><end><wait2>",
    "<bs><bs><bs><bs><wait2>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait5>",
    "<f10><wait10>"
  ]
  boot      = "c"
  boot_wait = "10s"

  # HTTP Configuration
  http_directory    = "http"
  http_bind_address = var.http_bind_address

  # SSH Configuration
  ssh_username = var.vm_ssh_username
  ssh_password = var.vm_ssh_password
  ssh_timeout  = "20m"
}

# Build Definition
build {
  name    = "ubuntu-server-jammy"
  sources = ["proxmox-iso.ubuntu-server-jammy"]

  # Cloud-Init Provisioning Step #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Cloud-Init Provisioning Step #2 - Upload File
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Cloud-Init Provisioning Step #3 - Configure Cloud-Init
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }
}
