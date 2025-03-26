#!/bin/bash

# Definir IP da instância e caminho da chave privada
EC2_HOST="ubuntu@44.211.144.79"
SSH_KEY="F:/terraform/keys/terraform-key-ec2.pem"

echo "=====> Criando diretórios no servidor..."
ssh -i $SSH_KEY $EC2_HOST "mkdir -p /home/ubuntu/desafio-terraform-novo/apache /home/ubuntu/desafio-terraform-novo/mysql"

echo "=====> Copiando arquivos do Apache..."
scp -i $SSH_KEY -r ./apache/* $EC2_HOST:/home/ubuntu/desafio-terraform-novo/apache/

echo "=====> Copiando arquivos do MySQL..."
scp -i $SSH_KEY -r ./mysql/* $EC2_HOST:/home/ubuntu/desafio-terraform-novo/mysql/

echo "=====> Criando containers Docker na EC2..."
ssh -i $SSH_KEY $EC2_HOST << 'EOF'
    # Criar imagem Apache
    docker build -t apache_php /home/ubuntu/desafio-terraform-novo/apache
    docker run -d --name apache_container -p 80:80 -v /home/ubuntu/desafio-terraform-novo/html:/var/www/html apache_php

    # Criar imagem MySQL
    docker build -t mysql_custom /home/ubuntu/desafio-terraform-novo/mysql
    docker run -d --name mysql_container --env-file /home/ubuntu/desafio-terraform-novo/mysql/.env -p 3306:3306 mysql_custom
EOF

echo "=====> Deploy finalizado!"
