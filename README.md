# Documentation de Terraform

## Prerequis:

- **Posséder un compte AWS**  
- **Installer AWS-CLI** : Pour gérer vos ressources AWS via la ligne de commande, installez AWS CLI et configurez-le avec aws configure. Lors de la configuration, entrez votre AWS Access Key ID, AWS Secret Access Key que vous allez trouver dans Vous pouvez installer AWS CLI , puis le configurer avec vos identifiants AWS, disponibles dans la section "AWS details" de votre compte AW, la région et le format de sortie. Une fois configuré, vous pouvez l'utiliser pour gérer vos instances EC2.
- **Installation de terraform** [Documentation Terraform](https://developer.hashicorp.com/terraform/install)
- **Informations d'identification AWS** : Configurer les informations d'identification AWS dans `./data/credentials` car elle sera utilisée par la suite avec Ansible.
- **Copier la clé SSH dans le dossier data** car elle sera utilisée par la suite avec Ansible.

## Mise en place du déploiement

 - Se placer dans le dossier contenant le code terraform.
 - Utilisez les commandes suivantes pour déployer l'application :
    
    ```bash
        terraform init
    ```
    ```bash
        terraform plan
    ```
    ```bash
        terraform apply
    ```
  Terraform informe de toutes les modifications qui seront apportées à l'infrastructure. Répondre **yes** à la question.

  Pour poursuivre l'installation de l'infrastructure via ansible. Suivre le [README2.md](https://github.com/RaphDuf/HACKATHON-IPSSI-equipe6/blob/infrastructure/README2.md)

## Suppression de l'infrastructure déployée 

Pour détruire l'infrastructure déployer par Terraform rentrer la commande suivante et répondre **yes** à la question : 

 ```bash
        terraform destroy
  ```


## main.tf
Ce fichier Terraform configure une infrastructure AWS basique. Il crée d'abord un **VPC** (Virtual Private Cloud) nommé *"main-vpc"* avec une plage d'adresses IP privées (`10.0.0.0/16`) et active la résolution DNS pour permettre aux ressources internes de se connecter via des noms DNS. 

Ensuite, il génère une paire de clés SSH **RSA** de 4096 bits localement à l'aide du provider **TLS**, puis importe la clé publique dans AWS sous le nom *"conexionnn-new"* pour pouvoir l'utiliser lors du lancement d'instances EC2. 

Enfin, la clé privée correspondante est sauvegardée localement dans un fichier sécurisé nommé *"conexionnn.pem"* avec des permissions restreintes, permettant à l'utilisateur d'accéder en SSH aux instances EC2 créées avec cette paire de clés.

## instances.tf
Ce code Terraform déploie une architecture AWS complète comprenant un Application Load Balancer (ALB) public nommé "loadbalancer-unique-14" qui répartit le trafic HTTP sur le port 80 entre plusieurs instances applicatives. Le load balancer est configuré dans deux sous-réseaux publics et associé à un groupe de sécurité dédié. Une instance bastion `t2.micro` est également lancée dans un subnet public pour permettre un accès sécurisé aux ressources privées via SSH, en utilisant une clé SSH préalablement créée. Cette instance bastion reçoit un fichier de clé privée avec les permissions sécurisées et exécute un script d'initialisation au démarrage. Trois instances applicatives identiques sont déployées dans un subnet privé, sans adresse IP publique, et attachées à un groupe cible du load balancer qui effectue des vérifications de santé pour ne router le trafic qu’aux instances opérationnelles. Enfin, un listener HTTP sur le port 80 est configuré sur le load balancer pour transmettre les requêtes au groupe cible. Cette architecture garantit une répartition du trafic efficace et sécurisée entre les instances applicatives tout en contrôlant l’accès via la bastion.

## security.tf
Ce code Terraform définit trois groupes de sécurité distincts pour sécuriser une architecture AWS. Le premier groupe, destiné au **Load Balancer**, autorise le trafic entrant sur les ports HTTP (80) et HTTPS (443) depuis n'importe quelle adresse IP, tout en permettant tout le trafic sortant. 

Le deuxième groupe de sécurité, pour l’**instance bastion**, permet l’accès SSH (port 22) depuis Internet, assurant un point d’entrée sécurisé pour administrer les ressources privées, avec un trafic sortant libre. 

Enfin, le troisième groupe s’applique aux **instances applicatives privées** et autorise uniquement le trafic HTTP et HTTPS provenant du groupe de sécurité du Load Balancer, ainsi que le trafic SSH depuis le groupe de sécurité de la bastion, tout en permettant un trafic sortant illimité. 

Cette configuration garantit que les instances applicatives ne sont accessibles que par le load balancer pour le trafic web et par le bastion pour la gestion SSH, renforçant ainsi la sécurité globale du système.

## reseau.tf
Ce code Terraform configure un réseau AWS complet en créant plusieurs sous-réseaux publics et privés dans un VPC. Trois sous-réseaux publics sont définis dans différentes zones de disponibilité pour héberger notamment le bastion et les load balancers, avec une configuration pour attribuer automatiquement des adresses IP publiques aux ressources qui y sont lancées. 

Deux sous-réseaux privés sont également créés dans d’autres zones, destinés à héberger les instances applicatives et bases de données, avec un groupe de sous-réseaux spécifique pour les bases. 

Une passerelle Internet est mise en place pour permettre l’accès public aux sous-réseaux publics, et une table de routage est configurée pour diriger le trafic sortant vers cette passerelle, associée à chacun des sous-réseaux publics. 

Pour les sous-réseaux privés, une passerelle NAT avec une adresse IP élastique est créée afin de permettre aux instances privées d’accéder à Internet sans être directement exposées, avec une table de routage dédiée redirigeant le trafic sortant vers cette passerelle NAT. 

Ainsi, ce code établit une infrastructure réseau sécurisée et scalable, en séparant les ressources publiques accessibles directement d’Internet des ressources privées protégées tout en leur permettant un accès sortant contrôlé.

## Liens entre les 4 fichiers Terraform
Les fichiers Terraform `main.tf`, `Security.tf`, `Instances.tf` et `reseau.tf` créent une infrastructure Cloud sécurisée sur AWS pour l'application **arcdata**, avec une architecture hautement disponible et segmentée.

- **`main.tf`** : Déclare le **VPC** (réseau privé) et configure la base SSH pour un accès sécurisé. Ce fichier sert de point d’entrée principal pour la création des ressources dans AWS.

- **`reseau.tf`** : Déploie la **topologie réseau**, créant des sous-réseaux publics (pour le bastion et le Load Balancer) et privés (pour les instances et la base de données), avec des tables de routage pour un accès sécurisé via **Internet Gateway** et **NAT Gateway**.

- **`Security.tf`** : Configure les **groupes de sécurité** :
  - Bastion : **SSH (port 22)** depuis une IP précise.
  - Load Balancer : **HTTP (port 80)** depuis l’extérieur.
  - Instances privées : Connexions **internes** uniquement.

- **`Instances.tf`** : Déploie les **ressources de calcul** : un **bastion** pour accéder aux instances privées, un **ALB** pour gérer le trafic HTTP vers 3 instances EC2 privées.
---





