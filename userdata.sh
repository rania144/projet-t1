#!/bin/bash

# Mettre à jour la liste des paquets
apt-get update -y

# Installer les dépendances nécessaires pour ajouter un PPA
apt-get install -y software-properties-common

# Ajouter le dépôt officiel d'Ansible
apt-add-repository --yes --update ppa:ansible/ansible

# Installer Ansible
apt-get install -y ansible

# Vérifier l'installation (optionnel)
ansible --version
