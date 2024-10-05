variable "haproxy_vm_config" {
  description = "A list of HAProxy VM configurations, including VM ID, IP address, and target node for each VM."
  type = list(object({
    vmid        = number
    ip          = string
    target_node = string
  }))
}

variable "haproxy_storage" {
  description = "Defines the storage type or mount point for HAProxy VMs, such as 'local-lvm' or another storage type."
  type        = string
  default     = "local-lvm"
}

variable "haproxy_storage_format" {
  description = "Specifies the format of the root storage for HAProxy VMs, such as 'raw', 'ext4', or 'xfs'."
  type        = string
  default     = "raw"
}

variable "haproxy_storage_size" {
  description = "Specifies the size of the root storage for each HAProxy VM, for example, '20G'."
  type        = string
  default     = "20G"
}

variable "haproxy_ci_user" {
  description = "The cloud-init username to be used for configuring HAProxy VMs."
  type        = string
}

variable "haproxy_ci_password" {
  description = "The cloud-init password to be used for configuring HAProxy VMs."
  type        = string
}

variable "haproxy_template" {
  description = "The Proxmox VM template to be used for creating HAProxy VMs."
  type        = string
}

variable "haproxy_startup" {
  description = "Defines the startup order for HAProxy VMs."
  type        = string
}

variable "haproxy_memory" {
  description = "The amount of memory (in MB) allocated to each HAProxy VM."
  type        = number
}

variable "haproxy_cpu" {
  description = "Specifies the CPU type for HAProxy VMs."
  type        = string
}

variable "haproxy_cpu_numa" {
  description = "Indicates whether NUMA (Non-Uniform Memory Access) is enabled or disabled for HAProxy VMs."
  type        = bool
}

variable "haproxy_cpu_sockets" {
  description = "The number of CPU sockets allocated to each HAProxy VM."
  type        = number
}

variable "haproxy_cpu_cores" {
  description = "The number of CPU cores per socket for HAProxy VMs."
  type        = number
}

variable "haproxy_gateway" {
  description = "The gateway IP address for HAProxy VMs."
  type        = string
}

variable "haproxy_subnet" {
  description = "The subnet mask for the network configuration of HAProxy VMs."
  type        = string
}

variable "haproxy_nameserver" {
  description = "The IP address of the DNS nameserver for HAProxy VMs."
  type        = string
}

variable "haproxy_network_model" {
  description = "Specifies the network model for HAProxy VMs."
  type        = string
}

variable "haproxy_network_bridge" {
  description = "The network bridge used for HAProxy VMs."
  type        = string
}

variable "haproxy_network_tag" {
  description = "The VLAN tag associated with the network configuration of HAProxy VMs."
  type        = number
}

variable "haproxy_network_firewall" {
  description = "Indicates whether the network firewall is enabled or disabled for HAProxy VMs."
  type        = bool
}
