terraform {
  # required_version = ">=1.8"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc3"
    }
  }
}

# Proxmox API configuration
provider "proxmox" {
  pm_parallel         = 1
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = var.proxmox_api_insecure
}

locals {
  ssh_public_key = file(var.ssh_public_key)
}
