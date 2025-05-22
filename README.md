# projet-t1
# 📄 Documentation de Terraform

## ✅ Prérequis

- Posséder un **compte AWS**
- Installer **AWS CLI** pour gérer les ressources AWS en ligne de commande :
  - Télécharger et installer AWS CLI : [Lien officiel](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
  - Configurer l'accès avec la commande :
    ```bash
    aws configure
    ```
    Lors de la configuration, renseignez :
    - **AWS Access Key ID**
    - **AWS Secret Access Key**
    - **Région** (ex: `eu-west-3` pour Paris)
    - **Format de sortie** (`json`, `table`, etc.)

- Installer **Terraform** : [Documentation officielle](https://developer.hashicorp.com/terraform/downloads)

- Configurer les **informations d'identification AWS** dans `./data/credentials`  
  (utilisées ensuite avec Ansible)

- Copier votre **clé SSH** dans le dossier `./data`  
  (nécessaire pour les connexions SSH via Ansible)

---

## 🚀 Déploiement de l'infrastructure

1. Ouvrir un terminal et se positionner dans le dossier contenant le code Terraform :
   ```bash
   cd path/to/votre/projet
