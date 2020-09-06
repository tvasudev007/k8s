# Kuberenetes cluster setup 

This repository is intended to spin up a kubernetes cluster using kubeadm in Azure cloud


### Prerequisites

The following softwares should already be installed to setup vm using vagrant

* [Terraform](https://www.terraform.io/downloads.html) - terraform download (Terraform v0.12.28 has been used)
* [AZ CLI]( https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) - az cli download (v2.0.60 has been used)
* [Ansible]( https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) - az cli download (v2.8.4 has been used)


### Getting started

A. Spin up base infrastructure

  1. Set azure subscription az account set --subscription="<subscription_id>"
  2. export ARM_ACCESS_KEY=""
  3. Navigate to ROOT-FOLDER > terraform > azure > east-us > compute folder
  4. Update your public IP at ROOT-FOLDER > terraform > azure > east-us > networking > variables.tf > my_public_ip or enter when prompted while running terraform apply
  5. Update your OS username at ROOT-FOLDER > terraform > azure > east-us > compute > variables.tf > admin-user or enter when prompted while running terraform apply
  6. Open a shell command prompt & from root folder change directory, run the following
     cd terraform/azure/east-us/compute
  7. Run the command 'terraform init' 
  8. Run the command 'terraform plan'
  9. Run the command 'terraform apply --auto-approve'

B. Configure base infrastructure & spin up K8s using kubeadm
 
  1. Get the public IP of bastion using
     az network public-ip list | grep ipAddress
  2. Add the following line the /etc/hosts (linux/mac users ) file & for Windows user c:\Windows\System32\Drivers\etc\hosts"
     <IP_address_from_above_command>   bastion.k8s
  3. Check, if present remove entries of bastion.k8s , master-1, worker-1 & workrer-2 from .ssh/known_hosts file
  4. Open a shell command prompt & from root folder run the following
     cd ansible 
  5. Now run 'ansible-playbook playbooks/prerequisites.yml -i hosts' 
  6. Run 'ansible-playbook playbooks/setting_up_nodes.yml -i hosts' to set up all nodes that includes docker installation network config etc
  7. Run 'ansible-playbook playbooks/configure_master_node.yml -i hosts' to download kubeadm and start master node
  8. Run 'ansible-playbook playbooks/configure_worker_node.yml -i hosts' to configure worker nodes and join them to K8s cluster
  9. Wait for few minutes and check whether the cluster is up and running by using the following command
     'kubectl get nodes -o wide'. You would see the list of nodes and their status which is 'Ready'
  
    
## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details


