# Лабораторна робота №4

## Архітектура

```
client 
    → VM1 (worker) [nginx :80 → Spring Boot :5000] 
    → VM2 (db) [MariaDB :3306]
```

| VM | Роль |
|---|---|
| lab4-worker | nginx + Spring Boot app |
| lab4-db | MariaDB |

---

## Передумови

- WSL2 з Ubuntu
- QEMU/KVM встановлений у WSL2
- Terraform ≥ 1.5
- Ansible ≥ 2.14

### Встановлення залежностей (WSL2)

```bash
# QEMU + libvirt
sudo apt install -y qemu-system-x86 libvirt-daemon-system libvirt-clients cloud-image-utils
sudo usermod -aG libvirt $USER
sudo systemctl enable --now libvirtd

# Terraform
sudo snap install terraform --classic

# Ansible
ansible-galaxy collection install community.mysql community.general
```

### Налаштування пулу libvirt

```bash
sudo virsh pool-define-as default dir - - - - /var/lib/libvirt/images
sudo virsh pool-build default
sudo virsh pool-start default
sudo virsh pool-autostart default
```

---

## Крок 1: Зібрати JAR

```bash
cd mywebapp
chmod +x gradlew
./gradlew bootJar -x test
```

---

## Крок 2: Terraform

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

Після завершення Terraform виведе IP адреси ВМ:
```
worker_ip = "192.168.122.XXX"
db_ip     = "192.168.122.YYY"
```

Оновити `ansible/inventory.ini` з реальними IP:
```ini
[workers]
worker ansible_host=<worker_ip>

[db]
db ansible_host=<db_ip>

[all:vars]
ansible_user=ansible
worker_ip=<worker_ip>
db_ip=<db_ip>
app_port=5000
```

---

## Крок 3: Ansible

```bash
cd ansible
ansible-playbook -i inventory.ini playbook.yml --ssh-extra-args="-o StrictHostKeyChecking=no"
```

Один запуск налаштовує все: MariaDB на VM2, Spring Boot + nginx на VM1, всіх користувачів.

---

## Перевірка

```bash
# Health checks
curl http://<worker_ip>/health/alive   # OK
curl http://<worker_ip>/health/ready   # OK (db check)

# API
curl http://<worker_ip>/items          # []
```

### Перевірка користувачів

```bash
# teacher (пароль: 12345678)
ssh -o PubkeyAuthentication=no teacher@<worker_ip>
sudo whoami  # root

# teacher на db VM (пароль: 12345678)
ssh -o PubkeyAuthentication=no teacher@<db_ip>
sudo whoami  # root

# operator (пароль: 12345678)
ssh -o PubkeyAuthentication=no operator@<worker_ip>

# Перевірка прав operator
sudo systemctl status mywebapp.service
sudo systemctl restart mywebapp.service
sudo systemctl reload nginx
```

### Перевірка firewall (DB недоступна ззовні)

```bash
nc -zv <db_ip> 3306   # має зависнути/відмовити
```

---

## Користувачі

| Користувач | ВМ | Пароль        | sudo |
|---|---|---------------|---|
| ansible | обидві | SSH ключ      | без пароля |
| teacher | обидві | 12345678      | з паролем |
| app | worker | (system user) | немає |
| operator | worker | 12345678      | тільки сервіси |

### Дозволені команди для operator

```bash
sudo systemctl start mywebapp.service
sudo systemctl stop mywebapp.service
sudo systemctl restart mywebapp.service
sudo systemctl status mywebapp.service
sudo systemctl reload nginx
```

---

## Знищити інфраструктуру

```bash
cd terraform
terraform destroy -auto-approve
```