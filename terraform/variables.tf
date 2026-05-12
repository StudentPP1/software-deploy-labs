variable "worker_ip" {
  description = "Static IP for worker VM on host-only network"
  default     = "192.168.56.10"
}

variable "db_ip" {
  description = "Static IP for DB VM on host-only network"
  default     = "192.168.56.11"
}

variable "host_only_interface" {
  description = "VirtualBox host-only network interface name (run: VBoxManage list hostonlyifs)"
  default     = "vboxnet0"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key (added to ansible user on both VMs)"
  default     = "~/.ssh/id_rsa.pub"
}
