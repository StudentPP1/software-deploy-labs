output "worker_ip" {
  description = "Worker VM IP (host-only network)"
  value       = var.worker_ip
}

output "db_ip" {
  description = "DB VM IP (host-only network)"
  value       = var.db_ip
}

output "ansible_inventory_hint" {
  description = "Run ansible-playbook with this inventory"
  value       = "ansible-playbook -i ../ansible/inventory.ini ../ansible/playbook.yml"
}
