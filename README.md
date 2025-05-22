# projet-t1
**Documentation de Terraform
Prerequis:
Posséder un compte AWS
Installer AWS-CLI : Pour gérer vos ressources AWS via la ligne de commande, installez AWS CLI et configurez-le avec aws configure. Lors de la configuration, entrez votre AWS Access Key ID, AWS Secret Access Key que vous allez trouver dans Vous pouvez installer AWS CLI , puis le configurer avec vos identifiants AWS, disponibles dans la section "AWS details" de votre compte AW, la région et le format de sortie. Une fois configuré, vous pouvez l'utiliser pour gérer vos instances EC2.
Installation de terraform Documentation Terraform
Informations d'identification AWS : Configurer les informations d'identification AWS dans ./credentials car elle sera utilisée par la suite avec Ansible.
Copier la clé SSH dans le dossier data car elle sera utilisée par la suite avec Ansible.
Mise en place du déploiement
Se placer dans le dossier contenant le code terraform.

Utilisez les commandes suivantes pour déployer l'application :

    terraform init
    terraform plan
    terraform apply
Terraform informe de toutes les modifications qui seront apportées à l'infrastructure. Répondre yes à la question.

Pour poursuivre l'installation de l'infrastructure via ansible. Suivre le README2.md

Suppression de l'infrastructure déployée
Pour détruire l'infrastructure déployer par Terraform rentrer la commande suivante et répondre yes à la question :

       terraform destroy
main.tf
Ce module Terraform commence par la déclaration du provider AWS, en spécifiant la région d’hébergement des ressources (ici, us-east-1). Il crée ensuite un Virtual Private Cloud (VPC), élément central du réseau dans AWS. Ce VPC utilise la plage d’adresses IP privée 10.0.0.0/16, avec l’activation du support DNS et des noms d’hôtes, ce qui est essentiel pour la résolution de noms au sein du réseau. Le VPC est également tagué pour une meilleure lisibilité dans la console AWS (Name = "main-vpc").

La seconde section permet de générer automatiquement une paire de clés SSH RSA 4096 bits à l’aide de Terraform et du provider tls. Cette clé permettrait un accès sécurisé aux futures instances EC2. La clé publique est alors importée dans AWS sous forme d’un aws_key_pair nommé connexion. La clé privée, quant à elle, est enregistrée localement dans un fichier .pem, avec des permissions strictes pour garantir la sécurité.

Instances.tf
Ce script Terraform déploie l’infrastructure complète de l’application GreenShop sur AWS en automatisant plusieurs composants clés :

Il commence par la création d’un Load Balancer de type application (ALB).

Ensuite, il instancie une machine bastion EC2

Trois instances EC2 privées hébergeant l'application sont ensuite déployées .

Ces instances sont rattachées à un groupe cible (Target Group) afin que le Load Balancer puisse répartir le trafic HTTP entre elles. Le script configure également un écouteur (listener) sur le port 80 pour rediriger les requêtes vers ces instances via le groupe cible.
