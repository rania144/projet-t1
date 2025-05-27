#!/bin/bash
# Mettre à jour les paquets
sudo apt update

# Installer Ansible (core)
sudo apt install ansible-core -y

# Créer le dossier Ansible s'il n'existe pas
mkdir -p /home/ubuntu/ansible

# Déplacer les fichiers dans le dossier ansible
mv /home/ubuntu/terraform/data/ansible.cfg \
   /home/ubuntu/terraform/data/aws_ec2.yml \
   /home/ubuntu/terraform/data/deploy_app.yml \
   /home/ubuntu/terraform/data/fail2ban.yml \
   /home/ubuntu/terraform/data/firewall.yml \
   /home/ubuntu/terraform/data/index.html \
   /home/ubuntu/terraform/data/update.yml \
   /home/ubuntu/terraform/data/users.yml \
   /home/ubuntu/ansible/

# Sécuriser les permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/ansible /home/ubuntu/.ssh
sudo chmod 755 /home/ubuntu/ansible
sudo chmod 600 /home/ubuntu/.ssh/conexionnn.pem

