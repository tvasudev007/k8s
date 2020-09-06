resource "azurerm_network_interface" "nic-worker-2" {
  name                            = "${var.prefix-worker-2}-nic"
  location                        = "${module.basic.location}"
  resource_group_name             = "${module.network.resource-group-name}"

  ip_configuration {
    name                          = "${var.prefix-worker-2}-ip-1"
    subnet_id                     = "${module.network.network-subnet-id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm-worker-2" {
  name                  = "${var.prefix-worker-2}"
  location              = "${module.basic.location}"
  resource_group_name   = "${module.network.resource-group-name}"
  network_interface_ids = [azurerm_network_interface.nic-worker-2.id]
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
    name              = "${var.prefix-worker-2}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "worker-2"
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