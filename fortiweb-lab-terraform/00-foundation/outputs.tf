output "guacamole_public_ip" {
  value = azurerm_public_ip.guac.ip_address
}

output "guacamole_fqdn" {
  description = "Azure DNS name used for Guacamole HTTPS (Let's Encrypt)."
  value       = azurerm_public_ip.guac.fqdn
}

output "guacamole_access" {
  description = "Guacamole jump host (IP only; full URL available after phase 03-routes)."
  value       = "${azurerm_public_ip.guac.ip_address}:8080"
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
