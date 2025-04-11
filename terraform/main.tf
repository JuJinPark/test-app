terraform {
  required_version = ">= 1.1.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "spring_app" {
  hostname     = "spring-app"
  target_node  = "pve"
  ostemplate   = "local:vztmpl/ubuntu-24.10-standard_24.10-1_amd64.tar.zst"
  password     = "changeme"
  cores        = 2
  memory       = 2048
  swap         = 1024
  rootfs       = "local-lvm:4"
  unprivileged = true
  start        = true
  net0         = "name=eth0,bridge=vmbr0,ip=dhcp"
  features {
    nesting = true
  }
  cicustom = "user=local:snippets/cloud-init.yaml"
}