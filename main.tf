provider "aws" {
  region = "us-east-1"
   profile = "default"  
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_security_group"
  description = "Permitir acesso SSH, HTTP e MySQL"
  vpc_id      = "vpc-03264446b721cc5f1"  

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

data "aws_instance" "ec2_instance" {
  instance_id = "i-02b9092fcaaf643b6"  
}

resource "null_resource" "ansible_deploy" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i 44.211.160.19, -u ubuntu --private-key /mnt/f/terraform/keys/terraform-key-ec2.pem deploy_apache_mysql.yml --ssh-extra-args='-o StrictHostKeyChecking=no'"
  }

  depends_on = [
    data.aws_instance.ec2_instance,
    aws_security_group.instance_sg
  ]
}
