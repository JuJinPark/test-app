terraform {
  required_version = ">= 1.1.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_api_token_id         = var.pm_api_token_id
  pm_api_token_secret     = var.pm_api_token_secret
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
  rootfs       {
    storage = "local-lvm"
    size    = "4G"
  }
  unprivileged = true
  start        = true

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
  features {
    nesting = true
  }
}