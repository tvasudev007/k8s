# Kuberenetes cluster setup 

This repository is intended to setup a spin up a kubernetes cluster using kubeadm in Azure cloud


### Prerequisites

The following softwares should already be installed to setup vm using vagrant

* [Terraform](https://www.terraform.io/downloads.html) - terraform cli download
* [AZ CLI]( https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) - az cli download


### Getting started

1. Set azure subscription az account set --subscription="<subscription_id>"
2. export ARM_ACCESS_KEY=""
3. Navigate to ROOT-FOLDER > terraform > azure > east-us > compute folder
4. Update your public IP in ROOT-FOLDER > terraform > azure > east-us > networking > variables.tf
4. Run the command 'terraform init'
5. Run the command 'terraform plan'
6. Run the command 'terraform apply --auto-approve'


## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE - see the [LICENSE](LICENSE) file for details


