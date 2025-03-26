# desafio-terraform-novo

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
