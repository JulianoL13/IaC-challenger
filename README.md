Small IaC to hosting http-server made in golang

# Ansible

ansible dir contains Ansible playbook to deploy the IaC to hosting http-server made in golang

run: ansible-playbook -i inventory playbook.yaml inside the ansible dir

## Requirements

- Ansible
- Python
- pip

# Terraform

Terraform file contains Terraform configuration to deploy the IaC to hosting http-server made in golang.

You can change the values in terraform.tfvars file to match your environment.

Run terraform init inside root dir.

You can validate the file using terraform validate.
