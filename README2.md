# Documentation du déploiement Ansible

## Introduction

Cette documentation décrit le processus d'automatisation du déploiement d'une application web sur des instances Amazon EC2 en utilisant Ansible. Elle détaille les fichiers de configuration nécessaires, leur fonctionnement, et les étapes de déploiement.

## Prérequis

- **Infrastructure fonctionnelle** comme présenté dans le README.md
- **Ansible** : Installer Ansible sur votre machine bastion. [Documentation Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
- **Récupérer le point de terminaison de la base de données**

## Fonctionnement du déploiement

Le déploiement fonctionne comme suit :

- **Inventaire Dynamique** : Utilisation du fichier `aws_ec2.yml` pour interroger l'API AWS et récupérer dynamiquement les instances EC2 correspondant à des critères spécifiques (tag Name).
- **playbook fail2ban**  :Ce playbook Ansible installe fail2ban sur tous les hôtes et s'assure qu'il est redémarré et activé au démarrage du système.
- **playbook firewall** :Ce playbook Ansible installe et configure le pare-feu UFW sur tous les hôtes en autorisant les connexions SSH, HTTP et HTTPS, puis l’active automatiquement.








