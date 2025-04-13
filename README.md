# Deploy do Apache e MySQL no Docker via Ansible e Terraform

Este projeto descreve o processo de criação de uma instância EC2 na AWS usando Terraform, configurando um Security Group para permitir tráfego HTTP e SSH, e realizando o deploy de containers Docker com Apache e MySQL utilizando Ansible.

## 1. Criação da Chave SSH

1. Gere uma chave SSH para acessar a instância EC2. No terminal, execute o comando:

   ```bash
   ssh-keygen -t rsa -b 4096 -f terraform-key
   ```

2. Isso criará dois arquivos: `terraform-key` (a chave privada) e `terraform-key.pub` (a chave pública).
   
3. A chave pública (`terraform-key.pub`) precisa ser adicionada ao perfil de usuário da AWS (em *EC2 Dashboard > Key Pairs*).

## 2. Criação da Instância EC2 via Terraform

Agora, vamos criar a instância EC2 utilizando o Terraform.

### 2.1. Inicializar o Terraform

No diretório do seu projeto Terraform, execute o comando abaixo para inicializar o Terraform:

```bash
terraform init
```

### 2.2. Criar o arquivo de configuração do Terraform

Crie o arquivo `main.tf` com a configuração da instância EC2 e do Security Group. Aqui está um exemplo básico de como configurar o Terraform para criar uma instância EC2:

```hcl
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-12345678"  # Substitua com a sua AMI
  instance_type = "t2.micro"
  key_name      = "terraform-key"  # Nome da chave SSH

  security_groups = [aws_security_group.instance_sg.name]

  tags = {
    Name = "EC2 Instance"
  }
}
```

**Explicação**:
- **Security Group**: Configura as regras de acesso à instância. O exemplo permite o tráfego SSH (porta 22) e HTTP (porta 80).
- **Instância EC2**: Cria uma instância EC2 com a AMI especificada, tipo de instância `t2.micro`, e associa a chave SSH gerada anteriormente.

### 2.3. Aplicar o Terraform

Após configurar o arquivo `main.tf`, execute o comando abaixo para criar a instância EC2 e o Security Group:

```bash
terraform apply
```

Este comando irá solicitar confirmação para aplicar as mudanças e criar os recursos especificados.

Ao final, o Terraform mostrará o IP público da instância EC2, que você usará mais tarde para o deploy com Ansible.

## 3. Configuração do Security Group

O Terraform já configura o Security Group para permitir o tráfego nas portas 22 (SSH) e 80 (HTTP) para a instância EC2 criada.

## 4. Deploy via Ansible

Agora, vamos configurar o deploy do Apache e MySQL no Docker dentro da instância EC2 utilizando Ansible.

### 4.1. Criar o Playbook do Ansible

Crie um arquivo `deploy.yml` com o conteúdo abaixo:

```yaml
---
- name: Deploy do Apache e MySQL no Docker via Ansible
  hosts: all
  become: true
  vars:
    apache_dir: /home/ubuntu/desafio-terraform-novo/apache
    mysql_dir: /home/ubuntu/desafio-terraform-novo/mysql
    html_dir: /home/ubuntu/desafio-terraform-novo/apache/public-html

  tasks:
    - name: Criar diretórios
      file:
        path: "{{ item }}"
        state: directory
        owner: ubuntu
        group: ubuntu
        mode: '0755'
      loop:
        - "{{ html_dir }}"
        - "{{ apache_dir }}"
        - "{{ mysql_dir }}"

    - name: Criar arquivo index.html para teste
      copy:
        content: "<h1>Servidor Apache funcionando!</h1>"
        dest: "{{ html_dir }}/index.html"
        mode: '0644'

    - name: Remover container Apache existente (se houver)
      community.docker.docker_container:
        name: apache_container
        state: absent
        force_kill: true

    - name: Remover container MySQL existente (se houver)
      community.docker.docker_container:
        name: mysql_container
        state: absent
        force_kill: true

    - name: Build da imagem do Apache
      community.docker.docker_image:
        name: apache-custom
        source: build
        build:
          path: "{{ apache_dir }}"

    - name: Build da imagem do MySQL
      community.docker.docker_image:
        name: mysql-custom
        source: build
        build:
          path: "{{ mysql_dir }}"

    - name: Subir container Apache
      community.docker.docker_container:
        name: apache_container
        image: apache-custom
        state: started
        ports:
          - "80:80"
        volumes:
          - "{{ html_dir }}:/var/www/html"

    - name: Subir container MySQL
      community.docker.docker_container:
        name: mysql_container
        image: mysql-custom
        state: started
        ports:
          - "3306:3306"
        env:
          MYSQL_ROOT_PASSWORD: metroid
          MYSQL_DATABASE: meubanco
          MYSQL_USER: admin
          MYSQL_PASSWORD: metroid
```

### 4.2. Rodar o Playbook Ansible

Agora, execute o playbook do Ansible na instância EC2 com o seguinte comando:

```bash
ansible-playbook -i <ip_publico_da_ec2>, -u ubuntu --private-key=terraform-key deploy.yml
```

Isso irá conectar-se à instância EC2, construir as imagens do Apache e MySQL, e subir os containers Docker com as configurações definidas.


# Atualização dia 20/03/2025 Deploy do container MySQL:
![image](https://github.com/user-attachments/assets/a0913f72-57ca-43f0-acb3-0b9493cdcb75)

Mike@DESKTOP-E4F3A7G:/mnt/f/terraform/desafio-terraform$ sudo ansible-playbook -i hosts.ini deploy_mysql.yml --limit servers

PLAY [Deploy do MySQL no Docker via Ansible] **************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [ec2]

TASK [Criar container MySQL] ******************************************************************************************************************************************
changed: [ec2]

PLAY RECAP ************************************************************************************************************************************************************
ec2                        : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Mike@DESKTOP-E4F3A7G:/mnt/f/terraform/desafio-terraform$

# Atualização dia 26/03/2025 Deploy do container Apache e MySQL

![image](https://github.com/user-attachments/assets/6205cbfa-92f3-4db3-9f34-48b997a8f727)

Mike@DESKTOP-E4F3A7G:/mnt/f/terraform/desafio-terraform$ sudo ansible-playbook -i hosts.ini deploy_apache_mysql.yml

PLAY [Deploy do Apache e MySQL no Docker via Ansible] *****************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************
ok: [ec2]

TASK [Criar diretório para o Apache] **********************************************************************************************************************************
ok: [ec2]

TASK [Criar Dockerfile do Apache] *************************************************************************************************************************************
ok: [ec2]

TASK [Criar diretório para o MySQL] ***********************************************************************************************************************************
ok: [ec2]

TASK [Criar Dockerfile do MySQL] **************************************************************************************************************************************
ok: [ec2]

TASK [Criar diretório para arquivos HTML] *****************************************************************************************************************************
ok: [ec2]

TASK [Criar um arquivo index.html para teste] *************************************************************************************************************************
ok: [ec2]

TASK [Remover container Apache existente (se houver)] *****************************************************************************************************************
changed: [ec2]

TASK [Criar container do Apache] **************************************************************************************************************************************
changed: [ec2]

TASK [Remover container MySQL existente (se houver)] ******************************************************************************************************************
changed: [ec2]

TASK [Criar container do MySQL] ***************************************************************************************************************************************
changed: [ec2]

PLAY RECAP ************************************************************************************************************************************************************
ec2                        : ok=11   changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Mike@DESKTOP-E4F3A7G:/mnt/f/terraform/desafio-terraform$
