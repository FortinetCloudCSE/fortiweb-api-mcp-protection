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

data "azurerm_public_ip" "guac" {
  name                = "pip-guacamole01"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "guac" {
  name                = "nic-guacamole01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = data.azurerm_subnet.client.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.3.200"
    public_ip_address_id          = data.azurerm_public_ip.guac.id
    primary                       = true
  }

  dynamic "ip_configuration" {
    for_each = ["10.10.3.201", "10.10.3.202", "10.10.3.203", "10.10.3.204", "10.10.3.205", "10.10.3.206"]
    content {
      name                          = "src-${replace(ip_configuration.value, ".", "-")}"
      subnet_id                     = data.azurerm_subnet.client.id
      private_ip_address_allocation = "Static"
      private_ip_address            = ip_configuration.value
    }
  }
}

resource "azurerm_network_interface" "docker1" {
  name                = "nic-linux-docker-1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = data.azurerm_subnet.server.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.1.200"
  }
}

resource "azurerm_network_interface" "docker2" {
  name                = "nic-linux-docker-2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = data.azurerm_subnet.server.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.1.202"
  }
}

# Specialized gallery images retain their existing accounts and must be
# deployed without an osProfile. azurerm_linux_virtual_machine always emits an
# osProfile, so use AzAPI for Guacamole and Docker1.
resource "azapi_resource" "guac" {
  type      = "Microsoft.Compute/virtualMachines@2024-07-01"
  name      = "guacamole01"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_resource_group.rg.location

  body = {
    properties = {
      hardwareProfile = {
        vmSize = var.guac_size
      }
      networkProfile = {
        networkInterfaces = [{
          id = azurerm_network_interface.guac.id
          properties = {
            primary = true
          }
        }]
      }
      storageProfile = {
        imageReference = {
          id = var.guac_image_id
        }
        osDisk = {
          name         = "guacamole01-osdisk"
          caching      = "ReadWrite"
          createOption = "FromImage"
          deleteOption = "Delete"
          managedDisk = {
            storageAccountType = "Premium_LRS"
          }
        }
      }
    }
  }
}

resource "azapi_resource" "docker1" {
  type      = "Microsoft.Compute/virtualMachines@2024-07-01"
  name      = "linux-docker-1"
  parent_id = data.azurerm_resource_group.rg.id
  location  = data.azurerm_resource_group.rg.location

  body = {
    properties = {
      hardwareProfile = {
        vmSize = var.docker_size
      }
      networkProfile = {
        networkInterfaces = [{
          id = azurerm_network_interface.docker1.id
          properties = {
            primary = true
          }
        }]
      }
      securityProfile = {
        securityType = "TrustedLaunch"
        uefiSettings = {
          secureBootEnabled = true
          vTpmEnabled       = true
        }
      }
      storageProfile = {
        imageReference = {
          id = var.docker1_image_id
        }
        osDisk = {
          name         = "linux-docker-1-osdisk"
          caching      = "ReadWrite"
          createOption = "FromImage"
          deleteOption = "Delete"
          managedDisk = {
            storageAccountType = "Premium_LRS"
          }
        }
      }
    }
  }
}

resource "azurerm_linux_virtual_machine" "docker2" {
  name                            = "linux-docker-2"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = var.docker_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.docker2.id]
  source_image_id                 = var.docker2_image_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}
