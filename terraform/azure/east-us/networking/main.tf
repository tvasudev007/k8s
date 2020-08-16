resource "azurerm_resource_group" "k8s-resources" {
  name     = "${var.prefix}-${module.basic.resource_group}"
  location = module.basic.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = module.basic.location
  resource_group_name = azurerm_resource_group.k8s-resources.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-network-subnet"
  resource_group_name  = azurerm_resource_group.k8s-resources.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = module.basic.location
  resource_group_name = azurerm_resource_group.k8s-resources.name
}

resource "azurerm_network_security_rule" "nsg-inbound" {
  name                        = "${var.prefix}-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.my_public_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.k8s-resources.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet-nsg" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}