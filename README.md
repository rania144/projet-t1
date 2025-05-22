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
