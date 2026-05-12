terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "worker" {
  name      = "lab4-worker"
  image     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  cpus      = 2
  memory    = "1024 mib"
  user_data = file("${path.module}/cloud-init/worker.yml")

  network_adapter {
    type           = "nat"
    device         = "IntelPro1000MTDesktop"
  }

  network_adapter {
    type           = "hostonly"
    host_interface = var.host_only_interface
    device         = "IntelPro1000MTDesktop"
  }
}

resource "virtualbox_vm" "db" {
  name      = "lab4-db"
  image     = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  cpus      = 1
  memory    = "512 mib"
  user_data = file("${path.module}/cloud-init/db.yml")

  network_adapter {
    type           = "nat"
    device         = "IntelPro1000MTDesktop"
  }

  network_adapter {
    type           = "hostonly"
    host_interface = var.host_only_interface
    device         = "IntelPro1000MTDesktop"
  }
}
