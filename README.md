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
