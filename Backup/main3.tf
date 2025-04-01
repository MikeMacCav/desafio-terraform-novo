provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "deploy_container" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("F:/terraform/keys/terraform-key-ec2.pem")
      host        = "44.201.170.182" 
    }

    inline = [
      
      "sudo apt update -y",
      "sudo apt install -y docker.io git",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",

      # Clonar ou atualizar repositório
      "if [ -d /home/ubuntu/desafio-terraform-novo ]; then cd /home/ubuntu/desafio-terraform-novo && git pull; else git clone https://github.com/MikeMacCav/desafio-terraform-novo.git /home/ubuntu/desafio-terraform-novo; fi",

      # Construir imagem Docker
      "cd /home/ubuntu/desafio-terraform-novo",
      "docker build -t desafio-image .",

      # Parar e remover container antigo, se existir
      "docker stop desafio-container || true",
      "docker rm desafio-container || true",

      # Rodar novo container
      "docker run -d -p 80:80 --name desafio-container desafio-image"
    ]
  }
}
