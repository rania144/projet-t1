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
Ce code Terraform déploie une architecture AWS comprenant un **load balancer**, une **instance bastion**, et plusieurs **instances applicatives**, tout en configurant leur interconnexion.

- **Load Balancer (ALB)** :  
  Il crée un *Application Load Balancer* public nommé `"loadbalancer-unique-14"` qui répartit le trafic HTTP entrant sur le port 80. Le load balancer est placé dans deux sous-réseaux publics (subnets) et associé à un groupe de sécurité spécifique. La protection contre la suppression accidentelle est désactivée.

- **Instance Bastion** :  
  Une instance EC2 `t2.micro` est lancée dans un subnet public, servant de point d’accès sécurisé (bastion host) pour se connecter aux autres instances privées. Elle utilise une AMI spécifique et la clé SSH `"conexionnn-new"` générée précédemment. Le fichier de clé privée SSH est copié sur cette instance via un provisioner, et les permissions de ce fichier sont sécurisées. Un script utilisateur (`userdata.sh`) est exécuté au démarrage pour configurer l’instance.

- **Instances Applicatives** :  
  Trois instances EC2 `t2.micro` sont lancées dans un subnet privé, sans adresse IP publique. Elles utilisent la même AMI et la clé SSH `"conexionnn-new"`. Chaque instance reçoit un nom distinct (application-1, application-2, application-3) via la variable `count`.

- **Target Group** :  
  Un groupe cible est créé pour le load balancer, qui écoute sur le port 80 en HTTP, dans le VPC principal. Il inclut une configuration de vérification de santé pour s’assurer que seules les instances saines reçoivent le trafic.

- **Listener Load Balancer** :  
  Le listener est configuré pour écouter les requêtes HTTP sur le port 80 et pour transférer le trafic vers le groupe cible.

- **Attachement au Target Group** :  
  Les trois instances applicatives sont attachées au groupe cible, ce qui permet au load balancer de distribuer les requêtes HTTP entre elles.

En résumé, ce code met en place une architecture réseau sécurisée avec un point d’entrée via un load balancer public, des instances applicatives privées derrière, et une instance bastion pour gérer l’accès sécurisé à l’environnement.


