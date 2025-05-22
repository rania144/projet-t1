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



