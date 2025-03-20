resource "aws_instance" "meu_servidor" {
  ami           = "ami-0fc5d935ebf8bc3bc" 
  instance_type = "t2.micro" 
  key_name      = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.instance_sg.name]

  tags = {
    Name = "ServidorEC2Terraform"
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "terraform-key-ec2"
  public_key = file("F:/terraform/keys/terraform-key-ec2.pub")
}

resource "aws_security_group" "instance_sg" {
  name = "meu_sg"
}
