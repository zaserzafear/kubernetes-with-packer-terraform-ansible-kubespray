variable "kube_node_vm_config" {
  description = "A list of Kubernetes Node VM configurations, including VM ID, IP address, and target node for each VM."
  type = list(object({
    vmid        = number
    ip          = string
    target_node = string
  }))
}

variable "kube_node_storage" {
  description = "Defines the storage type or mount point for Kubernetes Node VMs, such as 'local-lvm' or another storage type."
  type        = string
  default     = "local-lvm"
}

variable "kube_node_storage_format" {
  description = "Specifies the format of the root storage for Kubernetes Node VMs, such as 'raw', 'ext4', or 'xfs'."
  type        = string
  default     = "raw"
}

variable "kube_node_storage_size" {
  description = "Specifies the size of the root storage for each Kubernetes Node VM, for example, '20G'."
  type        = string
  default     = "20G"
}

variable "kube_node_ci_user" {
  description = "The cloud-init username to be used for configuring Kubernetes Node VMs."
  type        = string
}

variable "kube_node_ci_password" {
  description = "The cloud-init password to be used for configuring Kubernetes Node VMs."
  type        = string
}

variable "kube_node_template" {
  description = "The Proxmox VM template to be used for creating Kubernetes Node VMs."
  type        = string
}

variable "kube_node_startup" {
  description = "Defines the startup order for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_memory" {
  description = "The amount of memory (in MB) allocated to each Kubernetes Node VM."
  type        = number
}

variable "kube_node_cpu" {
  description = "Specifies the CPU type for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_cpu_numa" {
  description = "Indicates whether NUMA (Non-Uniform Memory Access) is enabled or disabled for Kubernetes Node VMs."
  type        = bool
}

variable "kube_node_cpu_sockets" {
  description = "The number of CPU sockets allocated to each Kubernetes Node VM."
  type        = number
}

variable "kube_node_cpu_cores" {
  description = "The number of CPU cores per socket for Kubernetes Node VMs."
  type        = number
}

variable "kube_node_gateway" {
  description = "The gateway IP address for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_subnet" {
  description = "The subnet mask for the network configuration of Kubernetes Node VMs."
  type        = string
}

variable "kube_node_nameserver" {
  description = "The IP address of the DNS nameserver for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_network_model" {
  description = "Specifies the network model for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_network_bridge" {
  description = "The network bridge used for Kubernetes Node VMs."
  type        = string
}

variable "kube_node_network_tag" {
  description = "The VLAN tag associated with the network configuration of Kubernetes Node VMs."
  type        = number
}

variable "kube_node_network_firewall" {
  description = "Indicates whether the network firewall is enabled or disabled for Kubernetes Node VMs."
  type        = bool
}
