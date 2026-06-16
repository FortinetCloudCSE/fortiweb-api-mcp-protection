data "azurerm_resource_group" "rg" { name = var.resource_group_name }
data "azurerm_subnet" "client" { name = "snet-client-10-10-3" virtual_network_name = var.vnet_name resource_group_name = var.resource_group_name }
data "azurerm_subnet" "server" { name = "snet-server-10-10-1" virtual_network_name = var.vnet_name resource_group_name = var.resource_group_name }
data "azurerm_public_ip" "guac" { name = "pip-guacamole01" resource_group_name = var.resource_group_name }

resource "azurerm_network_interface" "guac" {
  name                = "nic-guacamole01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration { name = "primary" subnet_id = data.azurerm_subnet.client.id private_ip_address_allocation = "Static" private_ip_address = "10.10.3.200" public_ip_address_id = data.azurerm_public_ip.guac.id primary = true }
  dynamic "ip_configuration" {
    for_each = ["10.10.3.201", "10.10.3.202", "10.10.3.203", "10.10.3.204", "10.10.3.205", "10.10.3.206"]
    content { name = "src-${replace(ip_configuration.value, ".", "-")}" subnet_id = data.azurerm_subnet.client.id private_ip_address_allocation = "Static" private_ip_address = ip_configuration.value }
  }
}
resource "azurerm_network_interface" "docker1" {
  name                = "nic-linux-docker-1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration { name = "primary" subnet_id = data.azurerm_subnet.server.id private_ip_address_allocation = "Static" private_ip_address = "10.10.1.200" }
}
resource "azurerm_network_interface" "docker2" {
  name                = "nic-linux-docker-2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_configuration { name = "primary" subnet_id = data.azurerm_subnet.server.id private_ip_address_allocation = "Static" private_ip_address = "10.10.1.201" }
}

resource "azurerm_linux_virtual_machine" "guac" {
  name                = "guacamole01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.guac_size
  network_interface_ids = [azurerm_network_interface.guac.id]
  source_image_id = var.guac_image_id
  os_disk { caching = "ReadWrite" storage_account_type = "Premium_LRS" }
}
resource "azurerm_linux_virtual_machine" "docker1" {
  name                = "linux-docker-1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.docker_size
  network_interface_ids = [azurerm_network_interface.docker1.id]
  source_image_id = var.docker1_image_id
  os_disk { caching = "ReadWrite" storage_account_type = "Premium_LRS" }
}
resource "azurerm_linux_virtual_machine" "docker2" {
  name                = "linux-docker-2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                = var.docker_size
  network_interface_ids = [azurerm_network_interface.docker2.id]
  source_image_id = var.docker2_image_id
  os_disk { caching = "ReadWrite" storage_account_type = "Premium_LRS" }
}
