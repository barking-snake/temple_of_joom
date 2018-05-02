provider "azurerm" { }

resource "azurerm_resource_group" "arch_sup" {
  name     = "archSupAssignment2ResourceGroup"
  location = "West US"
}

resource "azurerm_network_security_group" "arch_sup_pres_nsg" {
  name                = "archSupAssignmentPresNSG"
  location            = "${azurerm_resource_group.arch_sup.location}"
  resource_group_name = "${azurerm_resource_group.arch_sup.name}"

  security_rule {
    name                       = "SSHIn"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPIn"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPSIn"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "MySQLIn"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "InfluxIn"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "MySQLOut"
    priority                   = 150
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.0/24"
  }

  tags {
    environement = "Development"
  }
}

resource "azurerm_network_security_group" "arch_sup_data_nsg" {
  name                = "archSupAssignmentDataNSG"
  location            = "${azurerm_resource_group.arch_sup.location}"
  resource_group_name = "${azurerm_resource_group.arch_sup.name}"

  security_rule {
    name                       = "SSHIn"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "MySQLOut"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "MySQLIn"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "InfluxOut"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  tags {
    environement = "Development"
  }
}

resource "azurerm_virtual_network" "arch_sup" {
  name                = "archSupDevelopmentVNET"
  resource_group_name = "${azurerm_resource_group.arch_sup.name}"
  address_space       = ["10.0.0.0/16"]
  location            = "West US"

  subnet {
    name           = "presentaton"
    address_prefix = "10.0.1.0/24"
    security_group = "${azurerm_network_security_group.arch_sup_pres_nsg.id}"
  }

  subnet {
    name           = "data"
    address_prefix = "10.0.2.0/24"
    security_group = "${azurerm_network_security_group.arch_sup_data_nsg.id}"
  }

  tags {
    environment = "Development"
  }
}
