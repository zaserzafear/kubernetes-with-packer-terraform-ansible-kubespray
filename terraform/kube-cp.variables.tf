variable "kube_cp_vm_config" {
  description = "A list of Kubernetes Control Plane VM configurations, including VM ID, IP address, and target node for each VM."
  type = list(object({
    vmid        = number
    ip          = string
    target_node = string
  }))
}

variable "kube_cp_storage" {
  description = "Defines the storage type or mount point for Kubernetes Control Plane VMs, such as 'local-lvm' or another storage type."
  type        = string
  default     = "local-lvm"
}

variable "kube_cp_storage_format" {
  description = "Specifies the format of the root storage for Kubernetes Control Plane VMs, such as 'raw', 'ext4', or 'xfs'."
  type        = string
  default     = "raw"
}

variable "kube_cp_storage_size" {
  description = "Specifies the size of the root storage for each Kubernetes Control Plane VM, for example, '20G'."
  type        = string
  default     = "20G"
}

variable "kube_cp_ci_user" {
  description = "The cloud-init username to be used for configuring Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_ci_password" {
  description = "The cloud-init password to be used for configuring Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_template" {
  description = "The Proxmox VM template to be used for creating Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_startup" {
  description = "Defines the startup order for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_memory" {
  description = "The amount of memory (in MB) allocated to each Kubernetes Control Plane VM."
  type        = number
}

variable "kube_cp_cpu" {
  description = "Specifies the CPU type for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_cpu_numa" {
  description = "Indicates whether NUMA (Non-Uniform Memory Access) is enabled or disabled for Kubernetes Control Plane VMs."
  type        = bool
}

variable "kube_cp_cpu_sockets" {
  description = "The number of CPU sockets allocated to each Kubernetes Control Plane VM."
  type        = number
}

variable "kube_cp_cpu_cores" {
  description = "The number of CPU cores per socket for Kubernetes Control Plane VMs."
  type        = number
}

variable "kube_cp_gateway" {
  description = "The gateway IP address for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_subnet" {
  description = "The subnet mask for the network configuration of Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_nameserver" {
  description = "The IP address of the DNS nameserver for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_network_model" {
  description = "Specifies the network model for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_network_bridge" {
  description = "The network bridge used for Kubernetes Control Plane VMs."
  type        = string
}

variable "kube_cp_network_tag" {
  description = "The VLAN tag associated with the network configuration of Kubernetes Control Plane VMs."
  type        = number
}

variable "kube_cp_network_firewall" {
  description = "Indicates whether the network firewall is enabled or disabled for Kubernetes Control Plane VMs."
  type        = bool
}
