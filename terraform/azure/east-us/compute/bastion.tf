resource "azurerm_public_ip" "bastion_pip" {
  name                = "${var.prefix}-bastion-pip"
  resource_group_name = module.network.resource-group-name
  location            = "${module.basic.location}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic-bastion" {
  name                            = "${var.prefix}-bastion-nic"
  location                        = "${module.basic.location}"
  resource_group_name             = module.network.resource-group-name

  ip_configuration {
    name                          = "${var.prefix}-ip-1"
    subnet_id                     = "${module.network.network-subnet-id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bastion_pip.id}"
  }
}

resource "tls_private_key" "bootstrap_private_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-bastion"
  location              = "${module.basic.location}"
  resource_group_name   = "${module.network.resource-group-name}"
  network_interface_ids = ["${azurerm_network_interface.nic-bastion.id}"]
  vm_size               = "Standard_B2s"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-bastion-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-bastion"
    admin_username = "${var.admin-user}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin-user}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }

  }

}

resource "null_resource" "vm-ssh-keys" {

  depends_on = [azurerm_virtual_machine.vm]
  provisioner "file" {

    connection {
      type = "ssh"
      host = "${azurerm_public_ip.bastion_pip.ip_address}"
      user = "${var.admin-user}"
      private_key = file("~/.ssh/id_rsa")
    }

    source = "~/.ssh/id_rsa.pub"

    destination = "~/.ssh/id_rsa.pub"

  }
}

resource "null_resource" "vm-priv-ssh-keys" {

  depends_on = [azurerm_virtual_machine.vm]
  provisioner "file" {

    connection {
      type = "ssh"
      host = "${azurerm_public_ip.bastion_pip.ip_address}"
      user = "${var.admin-user}"
      private_key = file("~/.ssh/id_rsa")
    }

    source = "~/.ssh/id_rsa"

    destination = "~/.ssh/id_rsa"

  }
}

