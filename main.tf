provider "aws" {
  region = "us-east-1"  
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-key"
  public_key = file("F:/terraform/keys/terraform-key-ec2.pub") 
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_security_group"
  description = "Permitir acesso SSH, HTTP e MySQL"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["179.255.125.210/32"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu Server 24.04
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.instance_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y && sudo apt upgrade -y
              sudo apt install -y docker.io git
              sudo systemctl enable --now docker
              sudo usermod -aG docker ubuntu
              mkdir -p /home/ubuntu/desafio-terraform-novo
              chown -R ubuntu:ubuntu /home/ubuntu/desafio-terraform-novo              
              docker pull imagem-docker
              docker run -d --name container-docker -v /home/ubuntu/desafio-terraform-novo:/app imagem-docker
              EOF
  tags = {
    Name = "ServidorEC2Terraform"
  }
}

output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
