#!/bin/bash

# Definir IP da instância e caminho da chave privada
EC2_HOST="ubuntu@44.211.160.19"
SSH_KEY="F:/terraform/keys/terraform-key-ec2.pem"

echo "=====> Criando diretórios no servidor..."
ssh -i $SSH_KEY $EC2_HOST "mkdir -p /home/ubuntu/desafio-terraform-novo/apache/public-html /home/ubuntu/desafio-terraform-novo/apache /home/ubuntu/desafio-terraform-novo/mysql"

echo "=====> Copiando arquivos do Apache..."
scp -i $SSH_KEY -r ./apache/* $EC2_HOST:/home/ubuntu/desafio-terraform-novo/apache/

echo "=====> Copiando arquivos do MySQL..."
scp -i $SSH_KEY -r ./mysql/* $EC2_HOST:/home/ubuntu/desafio-terraform-novo/mysql/

echo "=====> Criando containers Docker na EC2..."
ssh -i $SSH_KEY $EC2_HOST << 'EOF'
    # Entrar no diretório Apache e construir a imagem
    cd /home/ubuntu/desafio-terraform-novo/apache
    docker build -t apache_php .

    # Rodar o container Apache
    docker run -d --name apache_container -p 80:80 -v /home/ubuntu/desafio-terraform-novo/apache/public-html:/usr/local/apache2/htdocs/ apache_php

    # Entrar no diretório MySQL e construir a imagem
    cd /home/ubuntu/desafio-terraform-novo/mysql
    docker build -t mysql_custom .

    # Rodar o container MySQL
    docker run -d --name mysql_container --env MYSQL_ROOT_PASSWORD=root --env MYSQL_DATABASE=desafio --env MYSQL_USER=admin --env MYSQL_PASSWORD=metroid -p 3306:3306 mysql_custom
EOF

echo "=====> Deploy finalizado!"
