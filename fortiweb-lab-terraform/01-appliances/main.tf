data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
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

data "azurerm_subnet" "client" {
  name                 = "snet-client-10-10-3"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

# Marketplace terms must be accepted once per subscription by an admin
# (student lab users typically lack Microsoft.MarketplaceOrdering permissions).
# Accept with:
#   az vm image terms accept --publisher fortinet --offer fortinet_fortigate-vm_v5 --plan fortinet_fg-vm_payg_20190624
#   az vm image terms accept --publisher fortinet --offer fortinet_fortiweb-vm_v5 --plan fortinet_fw-vm_payg_v3

resource "azurerm_network_interface" "fg_outside" {
  name                 = "nic-fgt-outside"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "outside"
    subnet_id                     = data.azurerm_subnet.client.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.3.101"
    primary                       = true
  }

  dynamic "ip_configuration" {
    for_each = ["10.10.3.150", "10.10.3.151", "10.10.3.152", "10.10.3.153"]
    content {
      name                          = "vip-${replace(ip_configuration.value, ".", "-")}"
      subnet_id                     = data.azurerm_subnet.client.id
      private_ip_address_allocation = "Static"
      private_ip_address            = ip_configuration.value
    }
  }
}

resource "azurerm_network_interface" "fg_inside" {
  name                 = "nic-fgt-inside"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "inside"
    subnet_id                     = data.azurerm_subnet.protected.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.2.101"
    primary                       = true
  }
}

resource "azurerm_network_interface" "fweb_protected" {
  name                 = "nic-fweb-protected"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "protected"
    subnet_id                     = data.azurerm_subnet.protected.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.2.100"
    primary                       = true
  }

  dynamic "ip_configuration" {
    for_each = ["10.10.2.150", "10.10.2.151", "10.10.2.152", "10.10.2.153"]
    content {
      name                          = "vip-${replace(ip_configuration.value, ".", "-")}"
      subnet_id                     = data.azurerm_subnet.protected.id
      private_ip_address_allocation = "Static"
      private_ip_address            = ip_configuration.value
    }
  }
}

resource "azurerm_network_interface" "fweb_server" {
  name                 = "nic-fweb-server"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "server"
    subnet_id                     = data.azurerm_subnet.server.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.1.100"
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "fortigate" {
  name                            = "FortiGate-VM01"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = var.fortigate_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.fg_outside.id, azurerm_network_interface.fg_inside.id]

  plan {
    publisher = var.fortigate_publisher
    product   = var.fortigate_offer
    name      = var.fortigate_sku
  }

  source_image_reference {
    publisher = var.fortigate_publisher
    offer     = var.fortigate_offer
    sku       = var.fortigate_sku
    version   = var.fortigate_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  custom_data = base64encode(templatefile("${path.module}/${var.fortigate_bootstrap_config}", {
    lab_student_password = var.fortigate_lab_student_password
  }))
}

resource "azurerm_linux_virtual_machine" "fortiweb" {
  name                            = "FortiWeb-VM01"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = var.fortiweb_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.fweb_protected.id, azurerm_network_interface.fweb_server.id]

  plan {
    publisher = var.fortiweb_publisher
    product   = var.fortiweb_offer
    name      = var.fortiweb_sku
  }

  source_image_reference {
    publisher = var.fortiweb_publisher
    offer     = var.fortiweb_offer
    sku       = var.fortiweb_sku
    version   = var.fortiweb_version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  custom_data = base64encode(templatefile("${path.module}/${var.fortiweb_bootstrap_config}", {
    lab_student_password = var.fortigate_lab_student_password
  }))
}

resource "azurerm_managed_disk" "fortiweb_data" {
  name                 = "disk-fortiweb-data-01"
  location             = data.azurerm_resource_group.rg.location
  resource_group_name  = data.azurerm_resource_group.rg.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.fortiweb_data_disk_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "fortiweb_data" {
  managed_disk_id    = azurerm_managed_disk.fortiweb_data.id
  virtual_machine_id = azurerm_linux_virtual_machine.fortiweb.id
  lun                = 0
  caching            = "ReadWrite"
}
