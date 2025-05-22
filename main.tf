provider "aws" {
  region = "us-east-1"
}

# Créer un VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Générer une paire de clés SSH
resource "tls_private_key" "conexionnn" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Importer la clé publique dans AWS avec un nom unique
resource "aws_key_pair" "conexionnn" {
  key_name   = "conexionnn-new" # NOM EXACT À UTILISER DANS LES INSTANCES
  public_key = tls_private_key.conexionnn.public_key_openssh
}

# Sauvegarder la clé privée localement dans un fichier .pem
resource "local_file" "private_key" {
  content         = tls_private_key.conexionnn.private_key_pem
  filename        = "${path.module}/conexionnn.pem"
  file_permission = "0600"
}