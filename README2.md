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
- **playbook update** :Ce playbook Ansible met à jour la liste des paquets disponibles puis effectue une mise à niveau complète (dist-upgrade) de tous les paquets installés sur tous les serveurs ciblés.
- **playbook deploy_app.yml**:Ce playbook installe un serveur Nginx, y déploie une page HTML personnalisée pour ARCData, et garantit que le service web est actif et persistant, facilitant ainsi le déploiement rapide d’un site statique sur plusieurs machines.

- **Résumé de l’enchaînement des playbooks**
**Sécurisation du serveur avec le playbook UFW**
Le premier playbook installe et configure le pare-feu UFW pour autoriser uniquement le trafic nécessaire (SSH, HTTP, HTTPS) et bloquer tout le reste. Cela garantit que le serveur est protégé dès le départ.

**Mise à jour du système avec le playbook de mise à jour**
Ensuite, le second playbook met à jour la liste des paquets disponibles puis applique toutes les mises à jour nécessaires, assurant que le serveur est à jour, stable et sécurisé avant l’installation des applications.

**Déploiement du site web avec le playbook ARCData**
Enfin, le dernier playbook installe le serveur web Nginx, copie les fichiers du site web et s’assure que Nginx est démarré et configuré pour démarrer automatiquement, rendant ainsi le site accessible aux utilisateurs. 








