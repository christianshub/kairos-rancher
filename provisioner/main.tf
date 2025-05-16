terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "kairos_vm_1" {

  name        = "kairos-cp-01"
  target_node = "proxmox"
  iso         = "local:iso/kairos-1.30-cp.iso"

  cores  = 2
  memory = 8000

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "20"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }


  ipconfig0 = "ip=192.168.0.150/24,gw=192.168.0.1"
}

resource "proxmox_vm_qemu" "kairos_vm_2" {
  name        = "kairos-cp-02"
  target_node = "proxmox"
  iso         = "local:iso/kairos-1.30-cp.iso"

  cores  = 2
  memory = 8000

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "20"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }


  ipconfig0 = "ip=192.168.0.151/24,gw=192.168.0.1"
}


resource "proxmox_vm_qemu" "kairos_vm_3" {

  name        = "kairos-worker-01"
  target_node = "proxmox"
  iso         = "local:iso/kairos-1.30-worker.iso"

  cores  = 2
  memory = 8000

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "30"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.0.152/24,gw=192.168.0.1"
}



resource "proxmox_vm_qemu" "kairos_vm_4" {

  name        = "kairos-worker-02"
  target_node = "proxmox"
  iso         = "local:iso/kairos-1.30-worker.iso"

  cores  = 2
  memory = 8000

  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "30"
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=192.168.0.152/24,gw=192.168.0.1"
}
