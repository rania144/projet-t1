# Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "loadbalancer-unique-14"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_security_group.id]
  subnets = [
    aws_subnet.public_subnet_load_balancer1.id,
    aws_subnet.public_subnet_load_balancer2.id
  ]
  enable_deletion_protection = false

  tags = {
    Name = "load_balancer"
  }
}

# Instance EC2 Bastion
resource "aws_instance" "bastion" {
  ami                         = "ami-084568db4383264d4" # à remplacer si besoin
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_bastion.id
  vpc_security_group_ids      = [aws_security_group.bastion_security_group.id]
  associate_public_ip_address = true
  key_name                    = "conexionnn-new"  # cohérent avec aws_key_pair

  provisioner "file" {
    source      = "${path.module}/conexionnn.pem"
    destination = "/home/ubuntu/.ssh/conexionnn.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.conexionnn.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/conexionnn.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.conexionnn.private_key_pem
      host        = self.public_ip
    }
  }

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "bastion"
  }
}

# Trois instances EC2 Application
resource "aws_instance" "application" {
  count                    = 3
  ami                      = "ami-084568db4383264d4"
  instance_type            = "t2.micro"
  subnet_id                = aws_subnet.private_subnet1.id
  vpc_security_group_ids   = [aws_security_group.application_security_group.id]
  associate_public_ip_address = false
  key_name                 = "conexionnn-new"

  tags = {
    Name = "application-${count.index + 1}"
  }
}

# Target Group pour le Load Balancer
resource "aws_lb_target_group" "tg" {
  name     = "loadbalancer-unique-14"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener pour le Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attachement des instances EC2 au Target Group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  count            = 3
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.application[count.index].id
  port             = 80
}
