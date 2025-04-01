provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGC5yuxU6eAz3i91ekDmVNgvCtpwD1BBRtnJOmQyTahzKceOtKoJztuXCPhoD2z98/BIGFr2V3OBS+J39m5rh9kdGfYJTKy/qFCmh4gvG4BCECMDH0udWvZ1DlzSABppal9S37dAf0l67pqh8vfmeV6ul8xAZozNDIOYPQRDHCzZjqQMeyMNk2qDJFAwID8tXml/egdaOzaaPihkEi9TijraLbww4Hcg2SnxEZPdu6lqz4Bv/Pc67cB0qtRjwSxD59MGg2vsxB0ETKhdsUYoFKsujF4lHhA8dPADTjXdPDtBaTbGkNBHvSiJdO6UMVTa3u2/MCRN35iFjz7CuGJh0JxSfpR/RU4ZOoZ59FF1/8QrXYCazCu6UrOWX4ZXqsnZPueY/3JZfQvXMtCKEl0dnRoERFmBZQPDhUMwSl+n9T8Z24hJvk3cQNGSVCn+wT/5UAumvWHOpn3ox0mBXENczEu1AxTHSMfTc2PToWkbWrxYEEecJgt+GieVXzsaerO6pD2hAysg1jjM5Xo07NCxsRONpyXERP7+j/3iKYYxEsvuJw7PYzz+38US2B0N2rkNPjtkh+j4jwEGiWyBsEMUomDZx7KqIWs33+7bgHChM4OpSxfnwTQCgzKn4hjCPQaoGt+yNC/PWF4jAQy1lp80toCB+sjgfuGMbkKl7J3CaXiw== Mike@FX8100Win10"
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

resource "aws_instance" "app_server" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]
  subnet_id = "subnet-045676d0f71462abd"
  tags = {
    Name = "ServidorEC2Terraform"
  }
}

resource "aws_instance" "meu_servidor" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [
    aws_security_group.instance_sg.id
  ]
  subnet_id = "subnet-045676d0f71462abd"
  tags = {
    Name = "ServidorEC2Terraform"
  }
}
