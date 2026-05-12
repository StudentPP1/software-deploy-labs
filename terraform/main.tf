terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-base"
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "worker" {
  name           = "worker.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  size           = 10737418240
}

resource "libvirt_volume" "db" {
  name           = "db.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  size           = 10737418240
}

resource "libvirt_cloudinit_disk" "worker" {
  name      = "worker-init.iso"
  user_data = file("${path.module}/cloud-init/worker.yml")
}

resource "libvirt_cloudinit_disk" "db" {
  name      = "db-init.iso"
  user_data = file("${path.module}/cloud-init/db.yml")
}

resource "libvirt_domain" "worker" {
  name   = "lab4-worker"
  memory = "1024"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.worker.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.worker.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

resource "libvirt_domain" "db" {
  name   = "lab4-db"
  memory = "512"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.db.id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.db.id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}