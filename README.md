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

# Atualização 07-04-2025 Deploy do container pelo Terraform usando o Ansible:
![image](https://github.com/user-attachments/assets/407deddc-42e2-4511-affe-2a8f9da9a3ba)

Mike@DESKTOP-E4F3A7G:/mnt/f/terraform/desafio-terraform$ sudo terraform apply
data.aws_instance.ec2_instance: Reading...
aws_security_group.instance_sg: Refreshing state... [id=sg-014ba83fa726c4fa0]
data.aws_instance.ec2_instance: Read complete after 4s [id=i-02b9092fcaaf643b6]
null_resource.ansible_deploy: Refreshing state... [id=4281393618800771832]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # null_resource.ansible_deploy is tainted, so must be replaced
-/+ resource "null_resource" "ansible_deploy" {
      ~ id = "4281393618800771832" -> (known after apply)
    }

Plan: 1 to add, 0 to change, 1 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.ansible_deploy: Destroying... [id=4281393618800771832]
null_resource.ansible_deploy: Destruction complete after 0s
null_resource.ansible_deploy: Creating...
null_resource.ansible_deploy: Provisioning with 'local-exec'...
null_resource.ansible_deploy (local-exec): Executing: ["/bin/sh" "-c" "ansible-playbook -i 3.83.106.36, --private-key F:/terraform/keys/terraform-key-ec2.pem deploy_apache_mysql.yml"]
null_resource.ansible_deploy (local-exec): [WARNING]: Could not match supplied host pattern, ignoring: ec2

null_resource.ansible_deploy (local-exec): PLAY [Deploy do Apache e MySQL no Docker via Ansible] **************************
null_resource.ansible_deploy (local-exec): skipping: no hosts matched

null_resource.ansible_deploy (local-exec): PLAY RECAP *********************************************************************

null_resource.ansible_deploy: Creation complete after 2s [id=4369597294433909958]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
