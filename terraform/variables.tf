# Proxmox API configuration
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
  type      = string
  sensitive = true
  default   = true
}

# Global Variables
variable "node_prefix" {
  description = "The prefix to be used for naming Virtual Machines (VMs) and other resources. This prefix helps to identify and organize resources related to a specific node or group of nodes in the infrastructure."
  type        = string
}

variable "env_name" {
  description = "The environment name for the deployment. This variable helps to differentiate between different environments such as development, staging, and production. It is used as a part of resource names and can be useful for environment-specific configuration and isolation."
  type        = string
}

variable "ssh_public_key" {
  description = "The SSH public key to be used for authentication"
  type        = string
  default     = "id_rsa.pub"
}
