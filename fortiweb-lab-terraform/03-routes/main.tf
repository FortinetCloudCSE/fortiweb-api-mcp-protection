data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_subnet" "client" {
  name                 = "snet-client-10-10-3"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "server" {
  name                 = "snet-server-10-10-1"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "protected" {
  name                 = "snet-protected-10-10-2"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_route_table" "client" {
  name                = "rt-client"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "to-server-through-fgt"
    address_prefix         = "10.10.1.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.3.101"
  }

  route {
    name                   = "to-protected-through-fgt"
    address_prefix         = "10.10.2.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.3.101"
  }
}

# Force FortiWeb return traffic to the client subnet through FortiGate so VIP
# reverse DNAT restores source 10.10.3.150 instead of 10.10.2.150.
resource "azurerm_route_table" "protected" {
  name                = "rt-protected-fortiweb"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "to-client-through-fgt"
    address_prefix         = "10.10.3.0/24"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.2.101"
  }
}

resource "azurerm_route_table" "fortiweb" {
  name                = "rt-fortiweb-server"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  route {
    name                   = "default-to-fortiweb-server"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.100"
  }
}

resource "azurerm_subnet_route_table_association" "client" {
  subnet_id      = data.azurerm_subnet.client.id
  route_table_id = azurerm_route_table.client.id
}

resource "azurerm_subnet_route_table_association" "protected" {
  subnet_id      = data.azurerm_subnet.protected.id
  route_table_id = azurerm_route_table.protected.id
}

resource "azurerm_subnet_route_table_association" "server" {
  subnet_id      = data.azurerm_subnet.server.id
  route_table_id = azurerm_route_table.fortiweb.id
}
