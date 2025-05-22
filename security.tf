# Groupe de sécurité pour le Load Balancer
resource "aws_security_group" "load_balancer_security_group" {
  name        = "load_balancer_security_group"
  description = "Allow HTTP and HTTPS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load_balancer_security_group"
  }
}

# Groupe de sécurité pour le Bastion
resource "aws_security_group" "bastion_security_group" {
  name        = "bastion_security_group"
  description = "Allow SSH access from the internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_security_group"
  }
}

# Groupe de sécurité pour les instances privées (Application)
resource "aws_security_group" "application_security_group" {
  name        = "application_security_group"
  description = "Allow HTTP/HTTPS from Load Balancer and SSH from Bastion"
  vpc_id      = aws_vpc.main.id

  # Autorise le HTTP depuis le Load Balancer
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  # Autorise le HTTPS depuis le Load Balancer
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  # Autorise le SSH depuis le Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application_security_group"
  }
}
