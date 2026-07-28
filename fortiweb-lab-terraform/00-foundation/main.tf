# Resource group is provisioned outside this project (one unique RG per student).
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "server" {
  name                 = "snet-server-10-10-1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}
resource "azurerm_subnet" "protected" {
  name                 = "snet-protected-10-10-2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.2.0/24"]
}
resource "azurerm_subnet" "client" {
  name                 = "snet-client-10-10-3"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.3.0/24"]
}

resource "azurerm_public_ip" "guac" {
  name                = "pip-guacamole01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "outbound" {
  name                = "pip-lab-outbound"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "outbound" {
  name                    = "natgw-lab-outbound"
  location                = data.azurerm_resource_group.rg.location
  resource_group_name     = data.azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "outbound" {
  nat_gateway_id       = azurerm_nat_gateway.outbound.id
  public_ip_address_id = azurerm_public_ip.outbound.id
}

resource "azurerm_subnet_nat_gateway_association" "protected" {
  subnet_id      = azurerm_subnet.protected.id
  nat_gateway_id = azurerm_nat_gateway.outbound.id
}

resource "azurerm_subnet_nat_gateway_association" "client" {
  subnet_id      = azurerm_subnet.client.id
  nat_gateway_id = azurerm_nat_gateway.outbound.id
}

resource "azurerm_network_security_group" "client" {
  name                = "nsg-client-guacamole"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-Guacamole-HTTP8080"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "10.10.3.200"
  }

  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_network_security_group" "server" {
  name                = "nsg-server-docker"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_network_security_group" "protected" {
  name                = "nsg-protected-appliances"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  security_rule {
    name                       = "Allow-VNet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_subnet_network_security_group_association" "client" {
  subnet_id                 = azurerm_subnet.client.id
  network_security_group_id = azurerm_network_security_group.client.id
}
resource "azurerm_subnet_network_security_group_association" "server" {
  subnet_id                 = azurerm_subnet.server.id
  network_security_group_id = azurerm_network_security_group.server.id
}
resource "azurerm_subnet_network_security_group_association" "protected" {
  subnet_id                 = azurerm_subnet.protected.id
  network_security_group_id = azurerm_network_security_group.protected.id
}
